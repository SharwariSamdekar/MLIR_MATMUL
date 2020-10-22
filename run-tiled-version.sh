
PATH_PREFIX=/data/sharwari
LLVM_ROOT=$PATH_PREFIX/MLIR/llvm-project
PROSPAR_MLIR=$PATH_PREFIX/prospar-mlir
LLVM_BUILD_PATH=$LLVM_ROOT/build
MLIR_OPT_EXEC=$LLVM_BUILD_PATH/bin/mlir-opt
MLIR_CPU_RUNNER_EXEC=$LLVM_BUILD_PATH/bin/mlir-cpu-runner
MLIR_RUNNER_LIB=$LLVM_BUILD_PATH/lib/libmlir_runner_utils.so
MLIR_SHARED_LIBS=$LLVM_BUILD_PATH/lib/libmlir_c_runner_utils.so

$MLIR_OPT_EXEC -convert-linalg-to-affine-loops  -convert-vector-to-scf -lower-affine -convert-scf-to-std -convert-vector-to-llvm -convert-std-to-llvm  $1 |  $MLIR_CPU_RUNNER_EXEC -O3 -e main -entry-point-result=void -lower-matrix-intrinsics -matrix-default-layout=row-major -shared-libs=$MLIR_RUNNER_LIB -shared-libs=$MLIR_SHARED_LIBS

$MLIR_OPT_EXEC -convert-linalg-to-affine-loops -lower-affine -convert-scf-to-std  -convert-std-to-llvm  $1 | $MLIR_CPU_RUNNER_EXEC -O3 -e main -entry-point-result=void -shared-libs=$MLIR_RUNNER_LIB -shared-libs=$MLIR_SHARED_LIBS

$MLIR_OPT_EXEC -affine-loop-tile="tile-sizes=64 tile-sizes=64 tile-sizes=64"  -convert-linalg-to-affine-loops -lower-affine -convert-scf-to-std  -convert-std-to-llvm  $1 | $MLIR_CPU_RUNNER_EXEC -O3 -e main -entry-point-result=void -shared-libs=$MLIR_RUNNER_LIB -shared-libs=$MLIR_SHARED_LIBS

$MLIR_OPT_EXEC -affine-loop-tile="tile-sizes=64 tile-sizes=64 tile-sizes=32" -convert-linalg-to-affine-loops -lower-affine -convert-scf-to-std  -convert-std-to-llvm  $1 | $MLIR_CPU_RUNNER_EXEC -O3 -e main -entry-point-result=void -shared-libs=$MLIR_RUNNER_LIB -shared-libs=$MLIR_SHARED_LIBS

$MLIR_OPT_EXEC -affine-loop-tile="tile-sizes=64 tile-sizes=32 tile-sizes=32"  -convert-linalg-to-affine-loops -lower-affine -convert-scf-to-std  -convert-std-to-llvm  $1 | $MLIR_CPU_RUNNER_EXEC -O3 -e main -entry-point-result=void -shared-libs=$MLIR_RUNNER_LIB -shared-libs=$MLIR_SHARED_LIBS

$MLIR_OPT_EXEC -affine-loop-tile="tile-sizes=32 tile-sizes=32 tile-sizes=32"  -convert-linalg-to-affine-loops -lower-affine -convert-scf-to-std  -convert-std-to-llvm  $1 | $MLIR_CPU_RUNNER_EXEC -O3 -e main -entry-point-result=void -shared-libs=$MLIR_RUNNER_LIB -shared-libs=$MLIR_SHARED_LIBS

$MLIR_OPT_EXEC -affine-loop-tile="tile-sizes=64 tile-sizes=64 tile-sizes=32" -affine-loop-unroll="unroll-up-to-factor" -convert-linalg-to-affine-loops -lower-affine -convert-scf-to-std  -convert-std-to-llvm  $1 | $MLIR_CPU_RUNNER_EXEC -O3 -e main -entry-point-result=void -shared-libs=$MLIR_RUNNER_LIB -shared-libs=$MLIR_SHARED_LIBS


