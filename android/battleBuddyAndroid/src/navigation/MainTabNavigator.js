import {createBottomTabNavigator} from 'react-navigation-tabs';
import itemsNavigator from './ItemsNavigator';
import learnNavigator from './LearnNavigator';
import moreNavigator from './MoreNavigator';

const Items = itemsNavigator;
const Learn = learnNavigator;
const More = moreNavigator;

const tabNavigator = createBottomTabNavigator(
  {Items, Learn, More},
  {
    tabBarOptions: {
      activeTintColor: '#FF491C',
      style: {
        backgroundColor: '#191919'
      }
    }
  }
);

tabNavigator.path = '';

export default tabNavigator;
