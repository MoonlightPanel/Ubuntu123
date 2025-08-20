# Ubuntu123
- DOCKER
```
# Clone the repository
git clone https://github.com/MoonlightPanel/Ubuntu123
cd Ubuntu123

# Build the Docker image
docker build -t ubuntu-vm .

# Run the container
docker run --privileged -p 6080:6080 -p 2221:2222 -v $PWD/vmdata:/data ubuntu-vm
```
- NO DOCKER
```
apt install curl -y && bash <(curl -Ls https://github.com/MoonlightPanel/Ubuntu123/raw/refs/heads/main/install.sh)
```
