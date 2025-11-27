# Waybar Configuration

## Preview

![a](https://github.com/user-attachments/assets/927f1f0f-1710-433a-9728-40345732065c)
![b](https://github.com/user-attachments/assets/29eb0303-0962-4547-a1fc-1d6b5575ba0b)

## Features

- **Hyprland Workspaces**: Elastic pill animations with numbered icons
- **Calendar tooltip**: The calendar can be viewed from the time module's tooltip
- **NetworkManager connectivity**

## Installation

1. Clone configuration files to `~/.config/waybar/`
2. Restart waybar: `pkill waybar && waybar &`

- For omrachy users, simply `Super + Shift + Space` to restart waybar

## Configuration

- `config.jsonc`: Main module configuration and settings
- `style.css`: Visual styling and animations
- Theme integration via `../omarchy/current/theme/waybar.css`

## Dependencies

- Hyprland window manager
- Nerd Font icons (CaskaydiaMono Nerd Font), though you could any nerd font
- PulseAudio for audio control
- NetworkManager for network status
