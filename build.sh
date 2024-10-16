#! /usr/bin/env bash
# Build OpenRailRouting with local Maven repository on file system.
# This script is useful if you fix bugs in the GraphHopper library.

set -euo pipefail

BASEDIR=$(pwd)
MAVEN_REPO="$BASEDIR/maven_repository"

echo "Puring maven_repository"
rm -rf "$MAVEN_REPO"/*

# Clone repositories if needed or skip based on changes
if [ -d "graphhopper" ]; then
  cd graphhopper
else
  echo "Cloning graphhopper repo"
  git clone https://github.com/graphhopper/graphhopper.git
  cd graphhopper
fi

# Run clean and compile in parallel
echo "Cleaning and Installing Graphhopper"
mvn -T 4C --projects core,web-bundle,map-matching,web-api -P include-client-hc -am -DskipTests=true compile package install

# Deploy files in bulk
echo "Deploying Graphhopper JARs"
for module in core web-bundle web-api map-matching; do
  mvn deploy:deploy-file -Durl=file://"$MAVEN_REPO" -Dfile=$module/target/graphhopper-$module-$GH_VERSION.jar \
    -DgroupId=com.graphhopper -DartifactId=graphhopper-$module -Dpackaging=jar -Dversion=$GH_VERSION
done

cd $BASEDIR

echo "Building OpenRailRouting"
MAVEN_OPTS="-Xms512m -Xmx2G -XX:+UseG1GC -Xss20m" mvn clean compile install -U -f pom-local-repository.xml
