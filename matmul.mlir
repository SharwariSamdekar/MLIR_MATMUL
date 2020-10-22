
!ASIZE = type memref<1024 x 1024 x f32>
!BSIZE = type memref<1024 x 1024 x f32>
!CSIZE = type memref<? x ? x f32>



func @main() {
  
  %A = alloc() : !ASIZE
  %B = alloc() : !BSIZE

  %c4 = constant 4.00000e+00 : f32
  %z = constant 0.00000e+00 : f32
  %i0 = constant 0 : index
  %i1 = constant 1 : index

  %p = dim %A, %i0 : !ASIZE
  %q = dim %A, %i1 : !ASIZE
  %r = dim %B, %i1 : !BSIZE

  %C = alloc(%p, %r) : !CSIZE
 

  linalg.fill(%A, %c4) : !ASIZE, f32
  linalg.fill(%B, %c4) : !BSIZE, f32
  linalg.fill(%C, %z) : !CSIZE, f32



  %tlin_start = call @rtclock() : () -> f64
  
  affine.for %i = 0 to %p {
      affine.for %j = 0 to %q{
          affine.for %k = 0 to %r{
              %a = affine.load %A[%i, %k] : !ASIZE
              %b = affine.load %B[%k, %j] : !BSIZE
              %c = affine.load %C[%i,%j] : !CSIZE

              %c1 = mulf %a, %b : f32
              %c2 = addf %c1, %c : f32
              affine.store %c2, %C[%i,%j] : !CSIZE
          }
      }
  }


  %tlin_end = call @rtclock() : () -> f64


  //Calculating sum of all elements of ouput matrix
  %sumo = alloc() : memref<1xf32>
  linalg.fill(%sumo,%z) : memref<1xf32>, f32

 
  affine.for %i = 0 to %p{
    affine.for %j = 0 to %r{
      %sum1 = affine.load %sumo[%i0] : memref<1xf32>
      %oe = affine.load %C[%i,%j] : !CSIZE
      %sum2 = addf %sum1, %oe : f32
      affine.store %sum2, %sumo[%i0] : memref<1xf32>
    }
  }

  // Printing Sum of Output
  %sumoc = memref_cast %sumo : memref<1xf32> to memref<*xf32>
  call @print_memref_f32(%sumoc) : (memref<*xf32>) -> ()


  // GFLOPS Calculation
  %tlin = subf %tlin_end, %tlin_start : f64
  %pi64 = index_cast %p : index to i64
  %qi64 = index_cast %q : index to i64
  %ri64 = index_cast %r : index to i64

  %f1 = muli %pi64, %qi64 : i64
  %f2 = muli %f1, %ri64 : i64
  %c2 = constant 2 : i64
  %f4 = muli %f2, %c2 :i64
  %num_flops_f = sitofp %f4 : i64 to f64
  %flops = divf %num_flops_f, %tlin : f64

  call @print_flops(%flops) : (f64) -> ()

  return
}
 func @print_memref_f32(memref<*xf32>)
 func @print_flops(f64)
 func @rtclock() -> f64


