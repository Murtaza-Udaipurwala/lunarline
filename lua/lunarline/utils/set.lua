local function set(components)
    local trunc_req = require('lunarline.utils.trunc_width')
    local filetree_icon = " פּ"
    local colors = {
        active = "%#active#",
        inactive = "%#inactive#",
    }

    function Set(focus)
        if focus == 'active' then
            if vim.bo.filetype == 'netrw' or vim.bo.filetype == "NvimTree" then
                return Set('filetree')
            end

            if trunc_req() then
                return table.concat({
                    components.get_mode(),
                    components.get_filename and components.get_filename(true) or "",
                    components.get_git_branch and components.get_git_branch() or "",
                }, ' ')
            else
                return table.concat({
                    components.get_mode(),
                    components.get_filename and components.get_filename(false) or "",
                    components.get_git_branch and components.get_git_branch() or "",
                    components.get_git_diff and components.get_git_diff() or "",
                    colors.active,
                    '%=',
                    components.get_active_clients and components.get_active_clients() or "",
                    components.get_diagnostics and components.get_diagnostics() or "",
                    components.get_cursor_position and components.get_cursor_position() or "",
                    components.get_line_col and components.get_line_col() or "",
                }, ' ')
            end
        elseif focus == 'filetree' then
            return colors.inactive .. "" .. filetree_icon
        else
            return colors.inactive
        end
    end
    vim.api.nvim_exec([[
    augroup Statusline
    au!
    au WinEnter,BufEnter * setlocal statusline=%!v:lua.Set('active')
    au WinLeave,BufLeave * setlocal statusline=%!v:lua.Set('inactive')
    augroup END
    ]], false)
end

return set