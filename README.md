QLC+ lighting control software implemented in a Docker container with VNC and web server support.

## Features

- **VNC Access**: Remote GUI access via VNC on port 5900
- **VNC Web Interface**: Browser-based easy VNC access on port 5800
- **QLC+ Web Server**: Optional web server on port 9999 for web access
- **Persistent Storage**: Volume support for workspaces, configurations, and custom content
- **Health Monitoring**: Built-in health checks
- **Custom Fixtures**: Support for custom fixture definitions

## Environment Variables

| Variable | Description | Default | Example |
|----------|-------------|---------|---------|
| `OPERATE_MODE` | Start QLC+ in operate mode (performance mode) | `""` | `true` |
| `QLC_WEB_SERVER` | Enable QLC+ web server on port 9999 | `""` | `true` |
| `WORKSPACE_FILE` | QLC+ workspace file to open at startup | `""` | `/data/show.qxw` |
| `VNC_PASSWORD` | Set VNC password for secure access | `""` | `mypassword` |

## Volume Mounts

| Path | Purpose | Recommended |
|------|---------|-------------|
| `/data` | QLC+ workspace files and user data | Yes |
| `/usr/share/qlcplus/fixtures/custom` | Custom fixture definitions | Optional |

## Docker Compose Examples

### Basic Setup
```yaml
services:
  qlcplus:
    image: scotttag/qlcplus-docker
    ports:
      - "5800:5800"  # Web interface
      - "5900:5900"  # VNC
    volumes:
      - qlcplus-data:/data:rw
    restart: unless-stopped

volumes:
  qlcplus-data:
```

### Advanced Setup with Web Server
```yaml
services:
  qlcplus:
    image: scotttag/qlcplus-docker
    network_mode: "host"
    restart: always
    volumes:
      - qlcplus-data:/data:rw
      - ./custom-fixtures:/usr/share/qlcplus/fixtures/custom:ro
    environment:
      - QLC_WEB_SERVER=true           # Enable web server on port 9999
      - WORKSPACE_FILE=/data/show.qxw # Auto-load workspace
      - OPERATE_MODE=true             # Start in performance mode
      - VNC_PASSWORD=secure_password  # Set VNC password
    healthcheck:
      test: ["CMD", "pgrep", "qlcplus"]
      interval: 30s
      timeout: 10s
      retries: 3

volumes:
  qlcplus-data:
```

### Development Setup
```yaml
services:
  qlcplus:
    image: scotttag/qlcplus-docker
    ports:
      - "5800:5800"  # Web interface
      - "5900:5900"  # VNC
      - "9999:9999"  # QLC+ web server
    volumes:
      - ./workspaces:/data:rw
      - ./fixtures:/usr/share/qlcplus/fixtures/custom:ro
    environment:
      - QLC_WEB_SERVER=true
    restart: unless-stopped
```

## Usage

1. **Access via Web Browser**: Navigate to `http://localhost:5800`
2. **Access via VNC Client**: Connect to `localhost:5900`
3. **QLC+ Web API**: If enabled, access at `http://localhost:9999`

## Security Considerations

⚠️ **Important**: This container exposes VNC and web interfaces. For secure deployments:

- **Set VNC Password**: Always set `VNC_PASSWORD` environment variable for VNC access
- **Network Security**: Place behind a reverse proxy with authentication for production use
- **Private Networks**: Use VPN or private networks to restrict access
- **Firewall Rules**: Configure firewall rules to limit access to trusted IPs only
- **Avoid Host Networking**: Do not use `network_mode: "host"` in production environments

### Root User Access

⚠️ **Note**: This container runs as root to provide simple access to hardware interfaces such as:
- **DMX Interfaces**: USB DMX controllers and adapters
- **Serial Devices**: RS485/RS232 lighting control devices  
- **Audio Interfaces**: For audio-triggered lighting effects
- **USB Devices**: Various lighting hardware peripherals

Running as root ensures QLC+ can access `/dev/` devices without complex permission configurations. If you don't need hardware access, consider network isolation and firewall rules for additional security.

### Secure Setup Example
```yaml
environment:
  - VNC_PASSWORD=your_secure_password_here
  - QLC_WEB_SERVER=true
```

## Building

To build the image locally:

```bash
docker build -t qlcplus-docker .
```

## Health Check

The container includes a health check that monitors the QLC+ process. Check status with:

```bash
docker inspect --format='{{.State.Health.Status}}' <container-name>
```

## Troubleshooting

- **QLC+ won't start**: Check logs with `docker logs <container-name>`
- **Workspace file not found**: Ensure the file exists in the mounted volume
- **Custom fixtures not loading**: Verify files are in `/usr/share/qlcplus/fixtures/custom`
- **Web server not accessible**: Ensure port 9999 is exposed and `QLC_WEB_SERVER=true`

## Contributing

Please submit issues and pull requests on the [GitHub repository](https://github.com/scotttag/qlcplus-docker).
