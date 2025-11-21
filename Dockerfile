# --- STAGE 1: Build the Static Assets with Parcel ---
# Use an official Node image to run the Parcel build process.
FROM node:20-slim AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and package-lock.json (if present)
# to install dependencies
COPY package*.json ./

# Install Parcel and other dependencies
RUN npm install

# Copy all source files into the container
COPY . .

# Run the Parcel build command
# The 'build' script is defined in package.json and outputs to the 'dist' directory.
RUN npm run build


# --- STAGE 2: Serve the Built Assets with NGINX ---
# Use a super-lightweight NGINX image to serve the static content.
FROM nginx:alpine

# Copy the built files from the 'builder' stage into the NGINX web root.
# Parcel outputs to the 'dist' folder, so we copy that content.
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose the standard HTTP port
EXPOSE 80

# The default command for the nginx:alpine image is 'nginx -g "daemon off;"'
CMD ["nginx", "-g", "daemon off;"]