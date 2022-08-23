Set-up 'pipewire`, `wireplumber` and all the requirements using [this gist](https://gist.github.com/PowerBall253/2dea6ddf6974ba4e5d26c3139ffb7580)

Then, if stuff hasn't been merged yet (it's not as of now) you should build `Hyprland` with patched wlroots. 
There's an AUR package for that: `hyprland-nvidia-screenshare-git`.
Just make sure you read the comments if anything goes wrong during build or at runtime... ;)

You can also swap the "screen selector" when sharing or recording by creating `~/.config/xdg-desktop-portal-wlr/config`
Where you can set your preferred option instead of `slurp`. 
For instance:

```
[screencast]
chooser_type=dmenu
chooser_cmd=wofi --show=dmenu
```
