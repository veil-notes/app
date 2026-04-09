class KdfParams {
  final String salt;
  final int iterations;
  final int memoryPowerOf2; //KB
  final int parallelism;
  final int length;

  const KdfParams({
    required this.salt,
    required this.iterations,
    required this.memoryPowerOf2,
    required this.parallelism,
    required this.length,
  });

   Map<String, dynamic> toJson() {
    return {
      'salt': salt,
      'iterations': iterations,
      'memoryPowerOf2': memoryPowerOf2,
      'parallelism': parallelism,
      'length': length,
    };
  }

  factory KdfParams.fromJson(Map<String, dynamic> json) {
    return KdfParams(
      salt: json['salt'] as String,
      iterations: json['iterations'] as int,
      memoryPowerOf2: json['memoryPowerOf2'] as int,
      parallelism: json['parallelism'] as int,
      length: json['length'] as int,
    );
  }
}
