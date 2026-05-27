### Steps To Use This Template

- replace the license file with your desired license
- rename solution, test, benchmarks, and main .csproj and reconnect their dependencies to eachother
  - I recommend using the included justfile with the command `just` [just command runner](https://github.com/casey/just)
- replace this readme

## Optionally
- double check the dotnet version in the main .csproj file, there is a table below with ideal versions for Unity & Godot
- add/remove items in .gitignore
- uncomment categories in .gitconfig to enable better merge tools for unity projects


### Unity & Godot Game Engine Language Support
*Last updated: 2026-05-27*

If you need to target both Unity and Godot, I would currently recommend netstandard 2.1 and C# 8. Unity is working on switching to MSBuild but I wouldn't expect it any time soon.

| Engine Version        | .NET Version         | C# Version | Backend        | Build System   | Compiler     | Nuget |
| --------------------- | -------------------- | ---------- | -------------- | -------------- | ------------ | ----- |
| Unity 4 or earlier    | .NET framework 3.5   | C# 3.5     | Mono           | Unity Build    | Proprietary  | ❌    |
| Unity 5               | .NET framework 3.5   | C# 3.5     | Mono or IL2CPP | Unity Build    | Proprietary  | ❌    |
| Unity 2017.1          | .NET framework 4.x   | C# 6.0     | Mono or IL2CPP | Unity Build    | Proprietary  | 🟨    |
| Unity 2018.1          | netstandard 2.0      | C# 7.3     | Mono or IL2CPP | Unity Build    | Proprietary  | 🟨    |         
| Unity 2021.2          | netstandard 2.1      | C# 9.0*    | Mono or IL2CPP | Unity Build    | Roslyn       | 🟨    |
| Unity 6               | netstandard 2.1      | C# 9.0*    | Mono or IL2CPP | Unity Build    | Roslyn       | 🟨    |
| Godot 3.x             | .NET framework 4.7.2 | C# 7.3     | Mono           | MSBuild        | Roslyn       | 🟨    |
| Godot 4.x Default     | .NET 8               | C# 12      | CoreCLR        | MSBuild        | Roslyn       | ✅    |
| Godot 4.x Web         | Unsupported ❌       | ❌         | ❌             | ❌             | ❌           | ❌    |
| Godot 4.x Android Min | .NET 9               | C# 13      | CoreCLR        | MSBuild        | Roslyn       | ✅    |
| Godot 4.x IOS Min     | .NET 8               | C# 12      | CoreCLR        | MSBuild        | Roslyn       | ✅    |
| Godot 4.x Max         | .NET 9               | C# 13      | CoreCLR        | MSBuild        | Roslyn       | ✅    |

- *[Unity does not support all features of C# 9](https://docs.unity3d.com/2021.2/Documentation/Manual/CSharpCompiler.html), It does fully support up through C# 8 in versions marked with *.
- 🟨 instructions for adding nuget packages to a Unity project can be found [here](https://learn.microsoft.com/en-us/visualstudio/gamedev/unity/unity-scripting-upgrade#add-packages-from-nuget-to-a-unity-project)
- 🟨 nuget package support in Godot 3.x was a little rough, expect to need to clear your build cache and restart the MSBuild server occaisionally
