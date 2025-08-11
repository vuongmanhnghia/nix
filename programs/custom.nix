{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    (appimageTools.wrapType2 rec {
      pname = "chat2db";
      version = "3.4.1";
      src = fetchurl {
        url = "https://github.com/CodePhiliaX/Chat2DB/releases/download/v${version}/Chat2DB-${version}.AppImage";
        sha256 = "sha256-oINB+NKEHwBdqT7+40r2pHwv2gL6JsBLckWZcTPmOk4=";
      };
      
      meta = with lib; {
        description = "AI-driven database tool and SQL client, supporting MySQL, Oracle, PostgreSQL, DB2, SQL Server, SQLite, H2, ClickHouse, and more.";
        homepage = "https://github.com/CodePhiliaX/Chat2DB";
        license = licenses.asl20;  # Apache License 2.0 (xem trong repo)
        platforms = platforms.linux;
        maintainers = [ ];
        sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      };
    })
  ];
}

