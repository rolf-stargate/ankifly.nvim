if exists('g:loaded_anki') | finish | endif " Prevent loading this file more than once

let s:save_cpo = &cpo " Save the current 'cpo' option"
set cpo&vim " rest them to defaults

" command to run our plugin
command! Anki lua require('anki').Anki.Run()

let &cpo = s:save_cpo " Restore the original 'cpo' option
unlet s:save_cpo
let g:loaded_anki = 1
