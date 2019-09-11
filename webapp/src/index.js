import React from 'react'
import ReactDOM from 'react-dom'
import { Provider } from 'react-redux'
import { createStore, applyMiddleware } from 'redux'
import thunkMiddleware from 'redux-thunk'
import { createLogger } from 'redux-logger'
import { Normalize } from 'styled-normalize'

import './i18n'
import rootReducer from './reducers'
import { GlobalStyle } from './styles/global-config';
import App from './App'
import * as serviceWorker from './serviceWorker'

const loggerMiddleware = createLogger()

const store = createStore(
    rootReducer,
    applyMiddleware(
        thunkMiddleware, // lets us dispatch() functions
        loggerMiddleware // neat middleware that logs actions
    )
  )
const rootElement = document.getElementById('root')

ReactDOM.render(
    <Provider store={store}>
        <Normalize />
        <GlobalStyle />
        <App />
    </Provider>,
    rootElement
);

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
