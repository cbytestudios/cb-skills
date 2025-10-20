# cb-skills

## Overview
The `cb-skills` resource provides a modular and extensible skill system for the RSG Framework, designed for RedM servers. It manages player skills (e.g., mining, smelting, prospecting, crafting) with experience points (XP) and levels, stored persistently in a MySQL database. The system uses metadata for in-memory operations to optimize performance, with database synchronization occurring on player logout and at periodic intervals (every 5 minutes). This resource serves as a dependency for other scripts that require skill progression, such as `cb-mining` and `cb-crafting`.

## Features
- Configurable skills with customizable XP thresholds, maximum levels, and bonuses (e.g., yield multipliers, time reductions).
- Persistent storage in a `skills_data` table with automatic table creation.
- Optimized database queries using metadata for in-memory operations.
- Exports for retrieving and updating skill data (`GetSkillData`, `AddSkillXP`).
- Periodic saving to database (every 5 minutes) and on player logout.

## Dependencies
- `rsg-core`: Required for core framework functionality, player management, and notifications.
- `oxmysql`: Required for MySQL database operations.

## Installation
1. **Add Resource to Server**:
   - Place the `cb-skills` folder in your server's `resources` directory.
   - Add `ensure cb-skills` to your `server.cfg`, ensuring it starts before dependent resources (e.g., `cb-mining`, `cb-crafting`).

2. **Database Setup**:
   - The resource automatically creates a `skills_data` table in your MySQL database on startup if it does not exist. No manual SQL execution is required.
   - Table structure:
     ```sql
     CREATE TABLE IF NOT EXISTS `skills_data` (
         `citizenid` VARCHAR(50) NOT NULL,
         `skill` VARCHAR(50) NOT NULL,
         `xp` INT DEFAULT 0,
         `level` INT DEFAULT 1,
         PRIMARY KEY (`citizenid`, `skill`)
     );
     ```

3. **Configuration**:
   - Edit `config.lua` to customize skills, XP per action, level thresholds, and bonuses.
   - Current skills: `mining`, `smelting`, `prospecting`, `crafting`. Add new skills as needed by extending the `Config.Skills` table.

4. **Items for rsg-inventory**:
   - No items are directly required by `cb-skills`, as it is a utility resource. However, dependent resources (`cb-mining`, `cb-crafting`) may require items (see their respective READMEs).

## Usage
- **Skill Management**:
  - Skills are initialized for players on join, loaded from the database, and stored in metadata.
  - Use `exports['cb-skills']:GetSkillData(source, skill)` to retrieve a player's XP and level for a skill.
  - Use `exports['cb-skills']:AddSkillXP(source, skill, amount)` to award XP and handle leveling.
- **Notifications**:
  - Players receive notifications on level-up and skill updates via the `RSGCore:Notify` system.
- **Extensibility**:
  - To add a new skill, define it in `config.lua` with its `xpPerAction`, `levelThresholds`, `maxLevel`, and `levelBonuses`. The system automatically handles database and metadata integration.

## Server Configuration
Add to `server.cfg`:
```cfg
ensure cb-skills
```

## Notes
- Ensure `oxmysql` is properly configured in your server environment.
- The `DrawText3D` function in dependent scripts may require a custom implementation or a third-party library for 3D text rendering.
- Test skill progression and database persistence thoroughly after adding new skills.

## Support
For issues or feature requests, contact the developer through the project's repository or community forums.
