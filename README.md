# qlcplus-docker
QLC+ implemented in a docker container with VNC and web server

Example docker-compose.yml
```
services:
  qlcplus:
    image: scotttag/qlcplus-docker
    network_mode: "host"
    restart: always
    volumes:
      - qlcplus:/data:rw
    environment:
      - QLC_WEB_SERVER=true # Enable QLC+ web server on port 9999
      - WORKSPACE_FILE=/data/startup.qxw # Open this file at startup
      - OPERATE_MODE=true # Start in operate mode

volumes:
  qlcplus:
```
