set runtimepath+=.
runtime plugin/telescope-history.lua

lua << EOF
require("telescope-history").setup()
EOF