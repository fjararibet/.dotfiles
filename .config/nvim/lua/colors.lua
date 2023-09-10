function ColorVim(color)
    color = color or "kanagawa"
    vim.cmd.colorscheme(color)

    -- if color == 'onedark' then
    --     return nil
    -- end

    -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorVim()
