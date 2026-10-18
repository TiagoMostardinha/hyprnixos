{ pkgs, ... }:

let
  name = "oblique-cursor";

  src = pkgs.fetchzip {
    url = "https://github.com/kayxean/oblique-cursor/releases/download/v1.0.0/oblique-cursor.tar.gz";
    hash = "sha256-pROJC0G2MTs5ktfMjISFrK9ZzZWE9upFuUzZLk/mdDo=";
  };

  theme =
    pkgs.runCommand "${name}-theme"
      {
        nativeBuildInputs = [
          pkgs.unzip
          pkgs.librsvg
          pkgs.xcursorgen
        ];
      }
      ''
        theme=$out/share/icons/${name}
        mkdir -p "$theme/cursors" work
        cp -r ${src}/. "$theme/"
        chmod -R u+w "$theme"

        for hlc in ${src}/shapes/*.hlc; do
          shape=$(basename "$hlc" .hlc)
          dir=work/$shape
          mkdir -p "$dir"
          unzip -q "$hlc" -d "$dir"

          hx=$(sed -n 's/^hotspot_x *= *//p' "$dir/meta.hl")
          hy=$(sed -n 's/^hotspot_y *= *//p' "$dir/meta.hl")
          svg=$(sed -n 's/^define_size *= *0, *//p' "$dir/meta.hl")

          : > "$dir/cfg"
          for size in 24 32 48 64 96; do
            rsvg-convert -w $size -h $size "$dir/$svg" -o "$dir/$size.png"
            px=$(awk -v s=$size -v h="$hx" 'BEGIN { printf "%d", h * s + 0.5 }')
            py=$(awk -v s=$size -v h="$hy" 'BEGIN { printf "%d", h * s + 0.5 }')
            echo "$size $px $py $dir/$size.png" >> "$dir/cfg"
          done
          xcursorgen "$dir/cfg" "$theme/cursors/$shape"

          for alias in $(sed -n 's/^define_override *= *//p' "$dir/meta.hl" | tr ';' ' '); do
            [ "$alias" = "$shape" ] || ln -sf "$shape" "$theme/cursors/$alias"
          done
        done

        printf '[Icon Theme]\nName=${name}\nComment=oblique-cursor (hyprcursor + XCursor)\n' > "$theme/index.theme"
      '';
in
{
  environment.systemPackages = [ theme ];

  services.displayManager.sddm.settings.Theme = {
    CursorTheme = name;
    CursorSize = 32;
  };
}
