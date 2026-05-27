using BenchmarkDotNet.Running;

namespace Benchmarks;

public class Program {
    static void Main(string[] args) =>
        BenchmarkSwitcher.FromAssembly(typeof(Program).Assembly).Run(args);
}
