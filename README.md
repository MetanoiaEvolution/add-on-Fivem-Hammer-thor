# Hammer Laser Interact with Force Push

This script enhances the **hammer** weapon in FiveM with interactive features such as a laser that follows the mouse direction. Players can explode, pull objects or players, and use **Force Push** (strong push). The script includes realistic animations for every action.

## Features
- **Laser Activation**: Typing `/togglehammer` activates a laser that follows the mouse.
- **Explosion**: Press **E** to trigger an explosion on the targeted object or player.
- **Pulling Objects/Players**: Press **G** to pull objects or players, or pull yourself to large objects like buildings.
- **Force Push**: Press **F** to push objects or players away with a strong force.
- **Animations**:
  - **Explosion**: Uses the **DAMN** animation.
  - **Pulling**: Uses a **tug-of-war** animation for pulling.
  - **Force Push**: Uses a push animation for Force Push.

## Controls
- **/togglehammer**: Activates or deactivates the laser for the hammer.
- **E**: Triggers an explosion.
- **G**: Pulls objects/players or pulls the player toward large objects.
- **F**: Activates Force Push to push objects or players.

## Installation

1. **Download the Script**:
   - Place the script into the `resources` folder on your FiveM server.

2. **Update `server.cfg`**:
   - Add the resource to your `server.cfg`:
     ```bash
     ensure hammer-laser-interact
     ```

3. **Restart the Server**:
   - Run the following command to restart the script:
     ```bash
     restart hammer-laser-interact
     ```

## Usage

1. Equip the **hammer** weapon.
2. Type `/togglehammer` to enable the laser.
3. Use the following keys for interactions:
   - **E**: Explode objects or players.
   - **G**: Pull objects/players or pull yourself to large objects.
   - **F**: Use Force Push to push objects or players away.

## Animations

- **Explosion (E)**: Plays the **DAMN** animation during explosions.
- **Pulling (G)**: Uses the **tug-of-war** animation when pulling objects or players.
- **Force Push (F)**: Plays a push animation when using Force Push.

## Customization

To customize keys or adjust force, edit the following variables:

- **Key Bindings**:
  - `explodeKey`: Key to trigger explosions.
  - `pullKey`: Key for pulling.
  - `forcePushKey`: Key for Force Push.
  
- **Adjust Force/Distance**:
  Modify values inside the `ApplyForceToEntity()` function for adjusting push/pull strength and distance.

## Known Issues
- The laser only functions when the hammer is equipped.
- Not all objects can be pulled; large static objects (e.g., buildings) will pull the player instead.

## License

This project is licensed under the MIT License. You are free to modify and distribute the script as needed.

## Support

For any questions or issues, contact the FiveM community or open an issue for assistance.

