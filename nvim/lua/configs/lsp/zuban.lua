vim.lsp.config["zuban"] = {
    cmd = {
        "zuban",
        "server"
    },
    filetypes = { 'python' },
    root_markers = {
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
        '.git',
    }
}
