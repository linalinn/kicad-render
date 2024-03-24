# kicad render action (WIP)

This actions allows you to automaticly render Images of your pcb and use it e.g. in a README.md

### current state
Rendering Image and Animations is working but the 3D models for kicad are missing since the offical docker image dose not contain the config that is created at first start up.

Even animation are renderd fine I wasn't able to embed them in to a README.md

Also this is using kicad nightly since there is yet no kicad relase containing the image rendering comand in the cli.


## Usage
1. Create the dirctory `.github/workflows` if it dose not already exists.

2. Add an new yaml in that dirctory e.g. pcb_image.yaml

3. Adding the configuration (you may need to replace `'refs/heads/main'` with `'refs/heads/master'` on older repos)
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
                pcb_file: m2sdr.kicad_pcb
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
    # My first pcb with automaitc image generation

    ### Images
    ![top](<github_username>.github.io/<repo_name>/images/top.png)
    ![bottom](<github_username>.github.io/<repo_name>/images/bottom.png)
    ```

6. Prepare the repo  
   - Open your repo on github
   - Open `Setting`
   - (Left side) click on `Pages`
   - Under `Build and deployment` select for `Source` `Github Action` from the dropdown.

5. git commit and push

## Animation original code
The [code](https://gist.github.com/arturo182/57ab066e6a4a36ee22979063e4d5cce1) for the Animation is from [arturo182](https://github.com/arturo182)  
[Mastdon post with Gif and link to gist](https://mastodon.social/@arturo182/112062074668232493)