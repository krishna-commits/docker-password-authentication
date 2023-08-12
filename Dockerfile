# Use the official Ubuntu base image
FROM ubuntu:latest

# Set environment variables for the new user and password
ENV USER_NAME=myuser
ENV USER_PASS=mypassword

# Create a new user and set the password
RUN useradd -m $USER_NAME && \
    echo "$USER_NAME:$USER_PASS" | chpasswd

# Install sudo and create a custom sudoers file to require password authentication
RUN apt-get update && \
    apt-get install -y sudo && \
    rm -rf /var/lib/apt/lists/* && \
    echo "$USER_NAME ALL=(ALL:ALL) ALL, !/bin/bash" > /etc/sudoers.d/custom_sudoers && \
    chmod 0440 /etc/sudoers.d/custom_sudoers

# Create a custom shell script to enforce password authentication for ls
RUN echo '#!/bin/bash\nsudo /bin/ls "$@"' > /usr/local/bin/ls && \
    chmod +x /usr/local/bin/ls

# Add /usr/local/bin to the beginning of PATH
ENV PATH="/usr/local/bin:${PATH}"

# Set the default user to the newly created user
USER $USER_NAME

# Set the working directory to the user's home directory
WORKDIR /home/$USER_NAME

# Start a shell when running the container
CMD ["/bin/bash"]
