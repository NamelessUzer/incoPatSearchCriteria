command! -nargs=0 Beauty_SearchCriteria call SearchCriteria#Beauty(<q-args>)
command! -nargs=? JoinLinesWithOR call JoinLinesWithOR(<q-args>)
command! -nargs=? SplitLineWithOR call SplitLineWithOR(<q-args>)
command! -nargs=? SortIPC call SortIPC(<q-args>)
command! -nargs=? GetElements call GetElements(<q-args>)
command! -nargs=? Copy_oneline call Copy_oneline(<q-args>)
command! -nargs=? GenerateSCFromList call GenerateSCFromList(<q-args>)
command! -nargs=? GenerateListFromSC call GenerateListFromSC(<q-args>)

