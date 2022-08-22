Please read https://gist.github.com/PowerBall253/2dea6ddf6974ba4e5d26c3139ffb7580


```
sudo pacman -S pipewire wireplumber xdg-desktop-portal-wlr 

# make sure there are no other portals installed/enabled
pacman -Q | grep xdg-desktop-portal- 

sudo pacman -S grim slurp
```

then restart your session.
