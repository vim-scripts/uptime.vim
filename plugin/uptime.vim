" Name:          uptime (global plugin)
" Version:       1.3
" Author:        Ciaran McCreesh <ciaranm at gentoo.org>
" Updates:       http://dev.gentoo.org/~ciaranm/vim/
" Purpose:       Display vim uptime
"
" License:       You may redistribute this plugin under the same terms as Vim
"                itself.
"
" Usage:         :Uptime
"                :Uptime regular   " default format
"                :Uptime short     " for 'short' format output
"                :Uptime seconds   " uptime in seconds
"
" Requirements:  Untested on Vim versions below 6.2
"
" ChangeLog:     see :help uptime-history

" when the plugin is sourced, record the time
let s:start_time = localtime()

" format output in seconds (doesn't do much)
function! s:FormatSeconds(uptime_in_seconds)
    return "" . a:uptime_in_seconds
endfun

" convert integer to 07 format (two digits is all we need)
function! s:AddLeadingZero(i)
    if a:i == 0
        return "00"
    elseif a:i < 10
        return "0" . a:i
    else
        return "" . a:i
    endif
endfun

" format short output
function! s:FormatShort(uptime_in_seconds)
    " get days, hours, minutes, seconds
    let l:m_s = (a:uptime_in_seconds) % 60
    let l:m_m = (a:uptime_in_seconds / 60) % 60
    let l:m_h = (a:uptime_in_seconds / (60 * 60)) % 24
    let l:m_d = (a:uptime_in_seconds / (60 * 60 * 24))

    let l:msg = ""
    if (l:m_d > 0)
        let l:msg = l:msg . l:m_d . "d "
    endif
    let l:msg = l:msg . s:AddLeadingZero(l:m_h) . ":" .
                \       s:AddLeadingZero(l:m_m) . ":" .
                \       s:AddLeadingZero(l:m_s)
    return l:msg
endfun

" format regular output
function! s:FormatRegular(uptime_in_seconds)
    " get days, hours, minutes, seconds
    let l:m_s = (a:uptime_in_seconds) % 60
    let l:m_m = (a:uptime_in_seconds / 60) % 60
    let l:m_h = (a:uptime_in_seconds / (60 * 60)) % 24
    let l:m_d = (a:uptime_in_seconds / (60 * 60 * 24))

    let l:d = 0
    let l:msg = v:progname . strftime(" has been up for ")

    if l:d || (l:m_d > 0)
        let l:msg = l:msg . l:m_d . (l:m_d == 1 ? " day, " : " days, ")
        let l:d = 1
    endif

    if l:d || (l:m_h > 0)
        let l:msg = l:msg . l:m_h . (l:m_h == 1 ? " hour, " : " hours, ")
        let l:d = 1
    endif

    if l:d || (l:m_m > 0)
        let l:msg = l:msg . l:m_m . (l:m_m == 1 ? " minute" : " minutes")
                    \ . " and "
        let l:d = 1
    endif

    let l:msg = l:msg . l:m_s . (l:m_s == 1 ? " second " : " seconds ")

    return l:msg
endfun

" how long have we been up?
function! Uptime(...)
    let l:current_time = localtime()
    let l:uptime_in_seconds = l:current_time - s:start_time
    let l:result = ""

    if a:0 == 0
        let l:result = s:FormatRegular(l:uptime_in_seconds)
    elseif a:0 != 1
        throw "Expected 0 or 1 arguments but got " . a:0
    elseif a:1 ==? "regular" || a:1 ==? "" || a:1 ==? "1"
        let l:result = s:FormatRegular(l:uptime_in_seconds)
    elseif a:1 ==? "short" || a:1 ==? "2"
        let l:result = s:FormatShort(l:uptime_in_seconds)
    elseif a:1 ==? "seconds" || a:1 ==? "3"
        let l:result = s:FormatSeconds(l:uptime_in_seconds)
    else
        throw "Unrecognised format '" . a:1 . 
                    \ "' (expected 'regular', 'short' or 'seconds')"
    endif

    return l:result
endfun

command! -nargs=? Uptime :echo Uptime(<q-args>)

" vim: set tw=80 ts=4 et :
