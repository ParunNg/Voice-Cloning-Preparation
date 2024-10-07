FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
        git \
        curl \
        ffmpeg \
        python3.10 \
        python3.10-dev \
        python3.10-distutils \
        python3-pip \
        libglib2.0-0

# install VS Code (code-server) and essential extensions
RUN curl -fsSL https://code-server.dev/install.sh | sh
RUN code-server --install-extension ms-python.python \
                --install-extension ms-toolsai.jupyter

# Change default version of Python to 3.10
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 999 && \
    update-alternatives --config python3 && ln -s /usr/bin/python3 /usr/bin/python

# Upgrade pip
RUN python3 -m pip install --upgrade pip

ENV USE_FLASH_ATTENTION 1

# Install dependencies
RUN pip3 install ipykernel
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124
RUN pip3 install pydub
RUN pip3 install build
RUN pip3 install cmake
RUN pip3 install ninja
RUN pip3 install wheel
RUN pip3 install flash-attn --no-build-isolation
RUN pip3 install openai-whisper

# Set the working directory in the container
WORKDIR /code

# Define environment variable
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1