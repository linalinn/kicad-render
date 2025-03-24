# kicad render action
[![KiCad render  - for gitlab ](https://img.shields.io/badge/KiCad_render_-for_gitlab_-2ea44f?style=for-the-badge&logo=gitlab)](https://gitlab.com/linalinn/kicad-render)

This action allows you to automatically render Images of your PCB and use them e.g. in a README.md

## Usage
1. Create the directory `.github/workflows` if it does not already exist.

2. Add a new yaml in that directory e.g. pcb_image.yaml

3. Adding the configuration. Set the path to your .kicad_pcb file (you may need to replace `'refs/heads/main'` with `'refs/heads/master'` on older repos)
    ```yaml
    name: pcb_image
    on:
      push:
    jobs:
      render-image:
        name: render-image
        runs-on: ubuntu-latest
        steps:
          - name: Check out the repo
            uses: actions/checkout@v4

          - name: render pcb image
            uses: linalinn/kicad-render@main
            with:
              pcb_file: <path from repo root to .kicad_pcb>
              output_path: ${{ github.workspace }}/images
              background: transparent # Remove for no transparency
            
          - name: Setup Pages
            if: github.ref == 'refs/heads/main'
            uses: actions/configure-pages@v3

          - name: Upload Artifact
            if: github.ref == 'refs/heads/main'
            uses: actions/upload-pages-artifact@v1
            with:
              path: "images"

      deploy-pages:
        if: github.ref == 'refs/heads/main'
        runs-on: ubuntu-latest
        needs: render-image
          
        permissions:
          pages: write
          id-token: write

        environment:
          name: github-pages
          url: ${{ steps.deployment.outputs.page_url }}

        steps:
          - name: Deploy to GitHub Pages
            id: deployment
            uses: actions/deploy-pages@v2
    ```

4. Adding the images to an README.md
    ```Markdown
    # My first PCB with automatic image generation

    ### Images
    ![top](<github_username>.github.io/<repo_name>/top.png)
    ![bottom](<github_username>.github.io/<repo_name>/bottom.png)
    rendered with [kicad-render](https://github.com/linalinn/kicad-render)
    ```

6. Prepare the repo  
   - Open your repo on GitHub
   - Open `Setting`
   - (Left side) Click on `Pages`
   - Under `Build and deployment` select for `Source` `Github Action` from the dropdown.

5. git commit and push

### Rendering Animations
This Action can also render an Animation of you pcb rotating as gif or mp4 is can be enabled by adding `animation: gif` or `animation: mp4` 

```yaml
- name: render pcb image
  uses: linalinn/kicad-render@main
  with:
    pcb_file: <path from repo root to .kicad_pcb>
    output_path: ${{ github.workspace }}/images
    animation: gif
```

To display the animation in a `README.md` add the following to you README.md.  
**Note:** GitHubs CDN has a file size limit this is why the animation can't be bigger then **300x300px** 

```Markdown
![animation](<github_username>.github.io/<repo_name>/rotating.gif)
```

### Example
You can find a example [here in the m2sdr](https://github.com/HackModsOrg/m2sdr) and the workflow for it [here](https://github.com/HackModsOrg/m2sdr/blob/master/.github/workflows/images.yaml)

## pre render hook / installing fonts
By setting `pre_render` to a path with a sourceable bash script you can run commands the are getting executed before the Images are rendered. You also can set optional inputs for the action as variables in this file by prefixing the option with `INPUT_` and the option in capslock e.g. `background` becomes `INPUT_BACKGROUND`.

### Example for ms font
```bash
apt-get update --yes 
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
apt-get install --yes ttf-mscorefonts-installer
```

### Example for configureing the Action via pre render hook

```bash
KICAD_CLI_OPTIONAL_ARGS=" --quality high"
KICAD_CLI_OPTIONAL_ARGS="$KICAD_CLI_OPTIONAL_ARGS -w 2000" 
KICAD_CLI_OPTIONAL_ARGS="$KICAD_CLI_OPTIONAL_ARGS -h 2500"
KICAD_CLI_OPTIONAL_ARGS="$KICAD_CLI_OPTIONAL_ARGS --zoom 2"

export KICAD_CLI_OPTIONAL_ARGS="$KICAD_CLI_OPTIONAL_ARGS"
export INPUT_PREFIX="prefix-via pre-render"
```


## Animation original code
The [code](https://gist.github.com/arturo182/57ab066e6a4a36ee22979063e4d5cce1) for the Animation is from [arturo182](https://github.com/arturo182)  
[Mastdon post with Gif and link to gist](https://mastodon.social/@arturo182/112062074668232493)


## Development
In this repo, you find an `.devcontainer` folder. This is for making Development and testing easier by not having to install kicad-nightly on your system. Dev containers are supported by Visual Studio Code, JetBrains, and Github. Alternatively, you can run the following docker command in the repository root `docker run -v "$(pwd)":/pwd --workdir=/pwd --rm -it ghcr.io/linalinn/kicad:9.0 bash` and run kicad nightly from inside this container.