" Vim syntax file
" Language:	Search Criteria
" Maintainer:	Lin Kun <ssfjhh at gmail.com>
" Last Change:	2017 Oct 15

if exists("b:current_syntax")
    finish
endif

syntax clear
syntax case     ignore       " 忽略大小写

set cindent shiftwidth=8     " 自动缩进4空格
set tabstop=8                " 设置tab键的宽度

syntax keyword Keyword and or not to
syntax keyword Operator = > >= < <=
syntax keyword Delimiter $ * ?
syntax match scConnector "\c(\(\d\{,2}[wn]\|sen\|s\|p\))"
syntax match scKEY '\c\(r\|rad\|rpd\|ti\|ab\|tiab-dwpi\|claim\|ipc\|loc\|an\|rand-DWPI\|ad\|pn\|pd\|ap\|aee\|ap-add\|ap-country\|in\|in-DWPI\|lor\|lee\|lg\|ri-text\|status\|lgi-party\|ti\|ti-cn\|ti-otlang\|ti-en\|ti-dwpi\|ab\|ab-cn\|ab-otlang\|ab-en\|use-dwpi\|adv-dwpi\|novelty-dwpi\|abstract-dwpi\|DTD-DWPI\|ACTIVITY-DWPI\|MEC-DWPI\|FOC-DWPI\|DRAW-DWPI\|tiab\|tiab-dwpi\|claim\|first-claim\|first-claim-or\|indepclaims-cn\|depclaims-cn\|no-indepclaims\|no-depclaims\|first-claim-ts\|len-first-claim\|Claim-EN\|Claim-CN\|Claim-OT\|no-claim\|tiabc\|des\|des-ot\|des-en\|des-cn\|technical-field\|background-art\|disclosure\|mode-for-invention\|use-cn\|use-en\|effect-s-cn\|effect-ph-cn\|effect-cn\|effect-cn-3\|effect-cn-2\|effect-cn-1\|effect-triz\|all\|full\|filing-lang\|prd\|PRD-DWPI\|page\|vlstar\|vlstar-1\|vlstar-2\|vlstar-3\|reward-level\|reward-name\|reward-session\|std-type\|std-Project\|std-num\|std-company\|std-flag\|cas-no\|drug-name-cn\|drug-name-en\|company\|Brand-Name\|active-ingredient\|Target\|indication\|patent-expiration\|PED-patent-expiration\|ap\|ap-group\|ap-grouptt\|AP-ALL\|aptt\|CO-DWPI\|ap-or\|ap-ot\|ap-ts\|apnor\|ap-first\|no-ap\|aee\|aeett\|aor\|assign-party\|aeenor\|AOR-TYPE\|intt\|AEE-TYPE\|ap-otadd\|in\|in-or\|in-ot\|in-ts\|in-first\|no-in\|in-new-name\|in-current\|lor\|lee\|LOR-TYPE\|LEE-TYPE\|lgi-party\|at\|agc\|re-ap\|in-ap\|ri-me\|ri-ae\|ri-leader\|por\|pee\|ex\|ap-type\|ck-DWPI\|CK-TYPE-DWPI\|who\|patentee\|patenteett\|patenteenor\|ap-new-name\|ap-as\|ap-en\|ap-reg-location\|ap-company-org-type\|ap-estiblish-time\|ap-usc\|ap-reg-number\|ap-reg-status\|ap-list-code\|opponent\|ipc\|ipc-main\|ipc-section\|ipc-class\|ipc-subclass\|ipc-group\|IPCM-Section\|IPCM-Class\|IPCM-Subclass\|IPCM-Group\|ipc-subgroup\|ipc-low\|ipc-high\|IPCM-Low\|IPCM-High\|IPC-DWPI\|IPC-Section-dwpi\|IPC-Class-dwpi\|loc\|IPC-Subclass-DWPI\|IPC-GROUP-dwpi\|IPC-Subgroup-DWPI\|IPC-f-DWPI\|IPC-Section-f-dwpi\|IPC-Class-f-dwpi\|IPC-Subclass-f-DWPI\|IPC-GROUP-f-dwpi\|IPC-Subgroup-f-DWPI\|DC-DWPI\|DC-SECTION-DWPI\|DC-CLASS-DWPI\|MC-DWPI\|MC-section-DWPI\|MC-class-DWPI\|MC-group-DWPI\|MC-subgroup-DWPI\|MC-subgroupd-DWPI\|MC-fullmc-DWPI\|MC-fullmcx-DWPI\|loc-class\|loc\|loc-subclass\|ecla\|ecla-section\|ecla-class\|ecla-subclass\|ecla-group\|ecla-subgroup\|uc\|uc-main\|cpc\|cpc-section\|cpc-class\|cpc-subclass\|cpc-group\|cpc-subgroup\|fi\|bclass\|mbclas1\|mbclas2\|mbclas3\|mbclas4\|mbclass\|ft\|Class\|bclas1\|bclas2\|bclas3\|bclas4\|cpc-main\|cpcm-section\|cpcm-class\|cpcm-subclass\|cpcm-group\|cpcm-subgroup\|industry1\|mindustry1\|mindustry2\|industry2\|Industry-type\|Mkclas1\|Mkclas2\|sc-main\|sc-section\|sc-class\|sc-subclass\|Lngclas1\|Lngclas2\|Lngclas3\|Cpclas1\|Cpclas2\|Cpclas3\|digclas1\|digclas2\|digclas3\|ap-country\|in-country\|auth\|pnc\|ap-add\|pr-au\|pr-au-DWPI\|ORIPRC-DWPI\|ap-province\|pc-cn\|ap-pc\|city\|county\|PATENTEE-ADD\|PATENTEE-PROVINCE\|PATENTEE-CITY\|PATENTEE-COUNTY\|in-add\|IN-ADD-OTH\|IN-OR-ADD\|in-city\|in-state\|assign-country\|assignee-add\|assignee-cadd\|assign-state\|assign-city\|AEE-PROVINCE\|AEE-CITY\|AEE-COUNTY\|ASSIGNOR-ADD\|AOR-PROVINCE\|AOR-CITY\|AOR-COUNTY\|at-country\|at-add\|at-city\|at-state\|lgi-region\|where\|ap-country\|in-country\|auth\|pnc\|ap-add\|pr-au\|pr-au-DWPI\|ORIPRC-DWPI\|ap-province\|pc-cn\|ap-pc\|city\|county\|PATENTEE-ADD\|PATENTEE-PROVINCE\|PATENTEE-CITY\|PATENTEE-COUNTY\|in-add\|IN-ADD-OTH\|IN-OR-ADD\|in-city\|in-state\|assign-country\|assignee-add\|assignee-cadd\|assign-state\|assign-city\|AEE-PROVINCE\|AEE-CITY\|AEE-COUNTY\|ASSIGNOR-ADD\|AOR-PROVINCE\|AOR-CITY\|AOR-COUNTY\|at-country\|at-add\|at-city\|at-state\|lgi-region\|where\|ad\|radd-DWPI\|adm\|ady\|pd\|PU-DATE\|pdy\|pdm\|pr-date\|pr-date-DWPI\|pryear\|ori-prdate\|ct-ad\|ct-pd\|ctfw-ad\|ctfw-pd\|ctyear\|subex-date\|GRANT-DATE\|EXDT\|expiry-date\|expiry-year\|ecd\|pledgeyear\|assignyear\|licenseyear\|assign-date\|assign-rd\|ri-date\|lgi-date\|lgi-fd\|lgi-cd\|lgd\|pledge-date\|license-date\|license-sd\|license-td\|pledge-cd\|pledge-rd\|lgiyear\|lgi-fy\|lgi-cy\|patent-life\|ex-time\|pfex-time\|re-date\|in-date\|or-date\|reapp-date\|inapp-date\|ori-pryear\|ori-pryear-DWPI\|status\|status-lite\|lg\|lge\|lgf\|lgc\|ri-type\|ri-text\|ri-ap\|inapp-date\|re-decision\|ri-basis\|ri-point\|lgi-court\|lgi-judge\|lgi-firm\|lawyer\|lgi-cause\|assign-text\|lgi-ti\|lgi-text\|lgi-type\|lgi-no\|lgi-procedure\|lgi-plaintiff\|lgi-defendant\|license-type\|license-stage\|license-cs\|lee-current\|pee-current\|pledge-type\|pledge-stage\|lawtxt\|assign-flag\|Assign-times\|assign-no\|licence-flag\|Licence-times\|plege-flag\|pledge-times\|ree-flag\|lgi-flag\|Lgi-times\|action-types\|customs-Flag\|all-flag\|Tovalide-date\|ct\|ctfw\|ct-self\|ct-oth\|ctfw-self\|ctfw-oth\|ct-times\|ctfw-times\|ct-self-times\|ct-oth-times\|ctfw-self-times\|ctfw-oth-times\|fct\|fctfw\|ct-ap\|ctfw-ap\|fct-ap\|fctfw-ap\|ct-no\|ctfw-no\|ct-auth\|ctfw-auth\|ct-code\|ct-X\|fct-times\|fctfw-times\|ctnp\|ct-source\|ctfw-source\)\ze\s*=\s*[[(]\?'
syntax match scPC '\<\([A-HY]\d\{2}[A-Z]\d\{1,4}/\d\{1,6}\(\([A-Z]\d[A-Z]\d\?\|[A-Z]\d\?\)\|\.\(\d*[A-Z]\|\d\+\)\)\?\|[A-HY]\d\{2}[A-Z]\d\{1,4}/\d{1,6}\?\|[A-HY]\d\{2}[A-Z]\d\{1,4}/\?\|[A-HY]\d\{2}[A-Z]\?\|[A-HY]\)\>'
syntax match scUC '\<\d\+/\d\+\(\.\d\+\)\?\|\d\+/\|\d\+\>'
syntax match scComment /#.*/
syntax region scString matchgroup=scQuote start=/"/ end=/"/
" syntax region scString matchgroup=scQuote start=/\v"/ skip=/\v\\./ end=/\v"/ " 因为检索式不支持转义的特殊字符，因此skip参数是不需要的

highlight link scConnector Delimiter
highlight link scPC        Number
highlight link scUC        Number
highlight link scKEY       Identifier
highlight link scComment   Comment
highlight link scString    String

highlight scQuote ctermfg=green guifg=green

let b:current_syntax = "incoPatSearchCriteria"
