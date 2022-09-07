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


## IN GENERAL
To make screen sharing / screencast work on nvidia you need to patch `libwlroots` like so:
```
0001-nvidia-format-workaround.patch:

diff --git a/types/output/render.c b/types/output/render.c
index 2e38919a..97f78608 100644
--- a/types/output/render.c
+++ b/types/output/render.c
@@ -311,20 +311,5 @@ struct wlr_drm_format *output_pick_format(struct wlr_output *output,
 }

 uint32_t wlr_output_preferred_read_format(struct wlr_output *output) {
-	struct wlr_renderer *renderer = output->renderer;
-	assert(renderer != NULL);
-
-	if (!renderer->impl->preferred_read_format || !renderer->impl->read_pixels) {
-		return DRM_FORMAT_INVALID;
-	}
-
-	if (!output_attach_back_buffer(output, &output->pending, NULL)) {
-		return false;
-	}
-
-	uint32_t fmt = renderer->impl->preferred_read_format(renderer);
-
-	output_clear_back_buffer(output);
-
-	return fmt;
+	return DRM_FORMAT_XRGB8888;
 }
```


So here's the steps:

1. git clone libwlroots
2. patch -p1 < "${srcdir}/0001-nvidia-format-workaround.patch"
3. make && sudo make install

Then make sure sway or any other `wlroots` compositor is linking to the patched `libwlroots` library you just installed.

```
$ ldd $(which sway)|grep libwlroots
	libwlroots.so.11 => /usr/lib/libwlroots.so.11 (0x00007f5724653000)
```
You can either cleanup any other `wlroots` installation or swap the library with a link to the patched `.so` to force it without re-building/re-linking everyhing, like so:
```
[morro@master ~]$ ls -lah /usr/lib/libwlroots.so*
-rwxr-xr-x 1 root root 922K 23 ago 13.45 /usr/lib/libwlroots.so
lrwxrwxrwx 1 root root   28  7 set 15.12 /usr/lib/libwlroots.so.11 -> /usr/lib/libwlroots.so.11032
-rwxr-xr-x 1 root root 922K 23 ago 13.45 /usr/lib/libwlroots.so.11032
-rwxr-xr-x 1 root root 865K 16 ago 09.53 /usr/lib/libwlroots.so.11.bak

```
(keep in mind that this is dirty and might not work)
