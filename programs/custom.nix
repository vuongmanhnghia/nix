# /etc/nixos/configuration.nix

{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Gói Chat2DB tùy chỉnh
    (let
      # Chat2DB yêu cầu Java 17. Chúng ta sẽ sử dụng phiên bản Temurin.
      jre = temurin-bin-17;
    in
      stdenv.mkDerivation rec {
        pname = "chat2db";
        version = "3.1.5"; # Đây là phiên bản mới nhất tại thời điểm viết

        # Tải xuống file .zip đã được build sẵn cho Linux từ GitHub
        src = fetchurl {
          url = "https://github.com/codePhiliaX/Chat2DB/releases/download/v${version}/Chat2DB-x64_${version}.zip";
          # Giá trị băm để đảm bảo tệp không bị thay đổi
          sha256 = "1bl0f1f1z82c6r7nnh92cc77j7433i98l0s81a02i39v801262w5";
        };

        # Các công cụ cần thiết để "cài đặt" gói này
        nativeBuildInputs = [ unzip makeWrapper ];

        # Nix sẽ không chạy các pha build hay configure tiêu chuẩn
        dontBuild = true;
        dontConfigure = true;

        # Hướng dẫn Nix cách cài đặt
        installPhase = ''
          # Tạo các thư mục cần thiết trong Nix store
          mkdir -p $out/lib/chat2db $out/bin

          # Giải nén mã nguồn vào thư mục lib
          unzip $src -d $out/lib/chat2db

          # Sửa đổi tệp script để nó sử dụng JRE từ NixOS thay vì JRE đi kèm
          substituteInPlace $out/lib/chat2db/Chat2DB.sh \
            --replace './jre/bin/java' '${jre}/bin/java'

          # Tạo một 'wrapper' để khởi chạy ứng dụng từ dòng lệnh
          makeWrapper $out/lib/chat2db/Chat2DB.sh $out/bin/chat2db
        '';

        # Thông tin mô tả về gói
        meta = with lib; {
          description = "A modern, intelligent, and powerful database client and data reporting tool.";
          homepage = "https://github.com/codePhiliaX/Chat2DB";
          license = licenses.unfree; # Giấy phép không phải là mã nguồn mở tiêu chuẩn
          platforms = platforms.linux;
        };
      }
    )
  ];
}