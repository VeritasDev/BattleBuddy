import {createBottomTabNavigator} from 'react-navigation-tabs';
import itemsNavigator from './ItemsNavigator';
import learnNavigator from './LearnNavigator';
import moreNavigator from './MoreNavigator';
import {theme} from '../components/Theme';

const Items = itemsNavigator;
const Learn = learnNavigator;
const More = moreNavigator;

const tabNavigator = createBottomTabNavigator(
  {Items, Learn, More},
  {
    tabBarOptions: {
      activeTintColor: theme.colors.orange,
      style: {
        backgroundColor: theme.colors.black,
        height: 60
      },
      keyboardHidesTabBar: false
    }
  }
);

export default tabNavigator;
