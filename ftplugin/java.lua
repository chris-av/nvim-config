local jdtls = require('jdtls')
local home = os.getenv('HOME')
local workspace_path = home .. '/.local/share/nvim/jdtls-workspace/'
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = workspace_path .. project_name

local extendedClientCapabilities = jdtls.extendedClientCapabilities

local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    -- jdtls executable
    vim.fn.expand('~/.local/share/nvim/mason/bin/jdtls'),

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',


    -- lombock setup here
    '-javaagent:' .. home .. './local/share/nvim/mason/packages/jdtls/lombok.jar',

    -- point to the correct eclipse equinox launcher
    '-jar', vim.fn.glob(home .. '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),


    -- NOTE: must point to correct config based on your OS
    '-configuration', home .. '/.local/share/nvim/mason/packages/jdtls/config_mac',
                    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
                    -- Must point to the                      Change to one of `linux`, `win` or `mac`
                    -- eclipse.jdt.ls installation            Depending on your system.

    '-data', workspace_dir,
  },

  root_dir = vim.fs.root(0, {".git", "mvnw", "gradlew", "pom.xml", "build.gradle"}),

  -- Here you can configure eclipse.jdt.ls specific settings
  settings = {
    java = {
      signatureHelp = { enabled = true, },
      extendedClientCapabilities = extendedClientCapabilities,
      maven = { downloadSources = true, },
      references = { includeDecompiledSources = true, },
    },
  },

  init_options = {
    bundles = {}
  },

  on_attach = on_attach,

}

jdtls.start_or_attach(config)
