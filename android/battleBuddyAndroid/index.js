import 'react-native-gesture-handler';
import {AppRegistry} from 'react-native';
import {name as appName} from './app.json';
import AppProviders from './AppProviders';

AppRegistry.registerComponent(appName, () => AppProviders);
