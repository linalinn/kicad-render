# kicad render action
[![KiCad render  - for gitlab ](https://img.shields.io/badge/KiCad_render_-for_gitlab_-2ea44f?style=for-the-badge&logo=gitlab)](https://gitlab.com/linalinn/kicad-render)

This action allows you to automatically render Images of your PCB and use them e.g. in a README.md

### current state

This is using Kicad nightly since there is yet no Kicad release containing the image rendering command in the CLI.


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
    ```

6. Prepare the repo  
   - Open your repo on GitHub
   - Open `Setting`
   - (Left side) Click on `Pages`
   - Under `Build and deployment` select for `Source` `Github Action` from the dropdown.

5. git commit and push

### Example
You can find a example [here in the m2sdr](https://github.com/HackModsOrg/m2sdr) and the workflow for it [here](https://github.com/HackModsOrg/m2sdr/blob/master/.github/workflows/images.yaml)

## Animation original code
The [code](https://gist.github.com/arturo182/57ab066e6a4a36ee22979063e4d5cce1) for the Animation is from [arturo182](https://github.com/arturo182)  
[Mastdon post with Gif and link to gist](https://mastodon.social/@arturo182/112062074668232493)
