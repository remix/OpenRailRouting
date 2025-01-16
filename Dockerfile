FROM maven:3.9.5-eclipse-temurin-21

# Install additional dependencies
RUN apt-get update && apt-get install -y \
    curl \
    tar \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Set version of Graphhopper
ARG GH_VERSION=9.1-osm-reader-callbacks

# Download Graphhopper source code
RUN curl -L https://github.com/geofabrik/graphhopper/archive/refs/tags/${GH_VERSION}.tar.gz -o graphhopper.tar.gz
RUN mkdir -p /openrailrouting/graphhopper && tar -xzf graphhopper.tar.gz -C /openrailrouting/graphhopper --strip-components=1

# Remove tarball
RUN rm graphhopper.tar.gz

# Copy OpenRailRouting source code into the container
COPY . /openrailrouting

# Set working directory to OpenRailRouting
WORKDIR /openrailrouting

# Clear Maven repository to ensure a fresh build
RUN rm -rf ~/.m2/repository/*

# Build OpenRailRouting and Graphhopper using Maven
RUN mvn clean install -DskipTests

# Expose necessary ports and run the application
EXPOSE 8989

CMD java -Xmx2G -Xms512m \
    -Ddw.graphhopper.graph.location=/openrailrouting/osm/data-gh \
    -Ddw.graphhopper.datareader.file=${OSM_PATH} \
    -jar target/railway_routing-1.0.0.jar server ./config.yml
