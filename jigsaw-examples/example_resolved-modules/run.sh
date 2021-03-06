. ../env.sh

echo "Running with root-module moda"
echo "   java --module-path mlib -m moda/pkga.AMain"
$JAVA_HOME/bin/java --module-path mlib -m moda/pkga.AMain | myecho

echo ------------------------------------------------------------------

echo "Running with root-module modb"
echo "   java --module-path mlib -m modb/pkgb.BMain"
$JAVA_HOME/bin/java --module-path mlib -m modb/pkgb.BMain | myecho

echo ------------------------------------------------------------------

echo "Running with root-module modc"
echo "   java --module-path mlib -m modc/pkgc.CMain"
$JAVA_HOME/bin/java --module-path mlib -m modc/pkgc.CMain | myecho

echo ------------------------------------------------------------------

echo "Running with root-module modb plus --add-modules modc"
echo "   java --module-path mlib --add-modules modc -m modb/pkgb.BMain"
$JAVA_HOME/bin/java --module-path mlib --add-modules modc -m modb/pkgb.BMain | myecho

echo ------------------------------------------------------------------

echo "Running with root-module modb plus automatic module javax.json"
echo "   java --module-path mlib${PATH_SEPARATOR}amlib -m modb/pkgb.BMain"
$JAVA_HOME/bin/java --module-path mlib${PATH_SEPARATOR}amlib -m modb/pkgb.BMain | myecho

echo ------------------------------------------------------------------

echo "Running with root-module modb plus limitmods"
echo "   java --module-path mlib --limit-modules modb -m modb/pkgb.BMain"
$JAVA_HOME/bin/java --module-path mlib --limit-modules modb -m modb/pkgb.BMain | myecho


echo ------------------------------------------------------------------

echo "Running with root-module modb plus limitmods on module java.logging and java.scripting (formerly java.compact1)"
echo "- Note that modb must be added to limitmods otherwise moda cannot be resolved"
echo "  (adding only moda would work too, but would be inconventient when modb has"
echo "   many requires)"
echo "   java --module-path mlib -limitmods java.logging,java.scripting,modb -m modb/pkgb.BMain"
$JAVA_HOME/bin/java --module-path mlib --limit-modules java.logging,java.scripting,modb -m modb/pkgb.BMain | myecho

echo ------------------------------------------------------------------

# /x/ doesn't work on module path, replace with x:
JAVA_HOME_OS=$JAVA_HOME
# /x/ doesn't work on module path on windows, replace with x:
(echo $OSTYPE | grep -i win >/dev/null) && JAVA_HOME_OS=$(echo $JAVA_HOME | sed -r s/^\\\/\([a-z]\)/\\\1:/)
echo "Linking with root module modb"
echo "   jlink --module-path mlib${PATH_SEPARATOR}$JAVA_HOME_OS/jmods --add-modules modb --output jimage/modb"
if [ -d ./jimage ]
then
  # otherwise error: directory does already exist...
  rm -rf ./jimage
fi
$JAVA_HOME/bin/jlink --module-path mlib${PATH_SEPARATOR}$JAVA_HOME_OS/jmods --add-modules modb --output jimage/modb | myecho

echo "Running the linked runtime image with root module modb"
echo "./jimage/modb/bin/java -m modb/pkgb.BMain"
./jimage/modb/bin/java -m modb/pkgb.BMain | myecho
