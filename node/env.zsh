alias y='yarn'
alias ya='yarn add -E'
alias yad='yarn add -E --dev'
alias yah='yarn audit --groups dependencies --level high'
alias yb='yarn build'
alias ybw='yarn build:watch'
alias ybs='yarn build:spec'
alias yi='yarn install'
alias yga='yarn global add'
alias yggql='yarn run generate:graphql:types'
alias ygjson='yarn run generate:json:types'
alias yl='yarn link'
alias yr='yarn remove'
alias yse='yarn build && yarn serve'
alias yst='yarn build && yarn start'
alias ysw='yarn build && yarn start:watch'
alias yt='yarn test'
alias ytuw='yarn test:unit:watch'
alias ytw='yarn test:watch'
alias ytc='yarn test:component'
alias yu='yarn unlink'
alias yo='yarn outdated'

export PATH="$PATH:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin"