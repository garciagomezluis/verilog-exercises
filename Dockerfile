FROM debian:latest

# Arguments for user and group
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USERNAME=devuser

RUN apt update && \
    apt install -y make python3 python3-pip libpython3-dev && \
    apt install -y gtkwave iverilog && \
    apt clean

RUN pip3 install --break-system-packages "cocotb~=1.9.2"

# Create user and switch to it
RUN groupadd --gid $GROUP_ID $USERNAME && \
    useradd --uid $USER_ID --gid $GROUP_ID --create-home $USERNAME

USER $USERNAME

WORKDIR /workspace
