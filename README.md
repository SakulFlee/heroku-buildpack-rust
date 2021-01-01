# Heroku BuildPack for Rust

This repository holds a [BuildPack] definition for [Heroku](https://heroku.com/).  
The main difference to other [BuildPacks] is that this one is freely configurable and supports multiple Rust/Cargo projects in one root.

What this [BuildPack] will do:

1. Check variables (some are required)
2. Check for git sub-modules
3. Prepare the build environment
4. Install or update Rustup (will be cached)
5. Build the project according to all settings

## Variables

There are multiple variables to be set.
Doing so can be done on Heroku in the app Settings under _Config Vars_.

| Key                     | Description                                                                                                                                                                                                                                                                                                             | (Default)                  |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| $RUST_TARGET            | The rust target architecture. Use `rustc --print target-list` for a list of targets. (Note: Not all might be supported on [Heroku])                                                                                                                                                                                     | `x86_64-unknown-linux-gnu` |
| $RUST_CHANNEL           | The rust channel (version). Commonly `stable`, `beta`, `nightly` or `dev`; but can also be any of [these](https://rust-lang.github.io/rustup-components-history/) for a specific version.                                                                                                                               | `stable`                   |
| $CARGO_WORKSPACE        | For multi-language workspaces: Use this to set the location to where your Rust project is. (See examples below)                                                                                                                                                                                                         |                            |
| $MANIFEST_PATH          | In case of multi-root rust workspaces or alternative names, set the **Path and Name** to your `Cargo.toml` (might be named differently). Pay attention when using `CARGO_WORKSPACE` and `MANIFEST_PATH` together; both will be concatenate following `<..>/CARGO_WORKSPACE/MANIFEST_PATH` pattern. (See examples below) | `Cargo.toml`               |
| $BIN                    | In case you want to build a specific binary: Name the binary name (from `[bin] name="..."` in `Cargo.toml`) here.                                                                                                                                                                                                       |                            |
| $EXAMPLE                | In case you want to build a specific example: Name the example name (from `[example] name="..."` in `Cargo.toml`) here.                                                                                                                                                                                                 |                            |
| $FEATURES               | If you require one or multiple features in your build, add them here (Comma separated like in `cargo`)                                                                                                                                                                                                                  |                            |
| $ADDITIONAL_CARGO_FLAGS | If you need some special flags (e.g. `--release`) add them here.                                                                                                                                                                                                                                                        |                            |

## Examples

The following are a few common use-cases/examples for this [BuildPack].

### Single Simple Rust Project

The project is a single rust project at the root of the repository.  
The `Cargo.toml` is directly in the root and nothing special is required for building.

Simply add the project to [Heroku] and add this [BuildPack].  
Everything should work out of the box! :)

### Single Rust Project, with special flags

In this case our project requires some special flags.
Let's say we want to compile a release version, thus we need the `--release` flag.

Follow the [Single Simple Rust Project](Single Simple Rust Project) guide and add the `--release` flag to `ADDITIONAL_CARGO_FLAGS` in the [Heroku] app settings.

### Multi-Project/Crate Repository / Cargo-Workspace, but only one binary is required

In this case we either have a multi-project/crate repository or a cargo-workspace.
Both work the same.

Let's say we have the following layout:

```none
(Cargo.toml) -- Cargo-Workspace root (optional)
    /frontend
        /src
            /...
        Cargo.toml
    /backend
        /src
            /...
        Cargo.toml
```

... and only want the backend to be build

Add the project to [Heroku] and set the following variables:

**Option 1**: Setting the `CARGO_WORKSPACE`

`$CARGO_WORKSPACE`: The location of your Cargo-project inside the repository. In this case: `backend`  
`$BIN/$EXAMPLE`: (Optionally) if there is a binary or example you specifically want to build.  
`$FEATURES`: (Optionally) if there are any feature flags that are required.  

**Option 2**: Setting the `MANIFEST_PATH`

`$MANIFEST_PATH`: Where the `Cargo.toml` is located. In this case `backend/Cargo.toml`.  
`$BIN/$EXAMPLE`: Same as **Option 1**  
`$FEATURES`: Same as **Option 1**  

> It might be easier to directly set the `$BIN` you want to build or `--project <name>` (via `ADDITIONAL_CARGO_FLAGS`).

Also note, that this not only works for Cargo-Workspaces, but the `backend` could be a Cargo project, while `frontend` is in e.g. NodeJS.

## Testing

Testing is currently done via the `test.sh` script in the root of this repository.
It creates a sample cargo project and executes the scripts on it, in a similar way to how Heroku is doing it.

This is only very basic functionally testing and may or may not discover flaws.
However, it will ensure the base functionally is working.

[BuildPack]: https://devcenter.heroku.com/articles/buildpacks
[BuildPacks]: https://devcenter.heroku.com/articles/buildpacks
