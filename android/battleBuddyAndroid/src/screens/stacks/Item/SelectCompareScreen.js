import React, {useState} from 'react';

import {ListItem} from 'react-native-elements';
import CheckBox from '@react-native-community/checkbox';
import styled from 'styled-components/native';
import {theme} from '../../../components/Theme';
import {Button, Alert} from 'react-native';
import {useItems} from '../../../context/ItemProvider';
import {useNavigation} from 'react-navigation-hooks';
import localeString from '../../../utils/localeString';
import LoadingIndicator from '../../../components/common/LoadingIndicator';

const ScrollView = styled.ScrollView`
  background: ${({theme}) => theme.colors.background};
  flex: 1;
`;

const Text = styled.Text`
  margin: 20px 0 10px 10px;
  font-size: 18px;
  color: ${({theme}) => theme.colors.white};
`;

const SelectCompareScreen = () => {
  const {state, navigate} = useNavigation();
  const [selectedItems, setSelectedItem] = useState([
    state.params.selectedItem._id
  ]);

  const {loading, data: docs} = useItems();

  const handleSelect = ({_id}) => {
    if (!selectedItems.includes(_id)) {
      setSelectedItem((prevState) => [...prevState, _id]);
    } else {
      setSelectedItem((prevState) => {
        return prevState.filter((x) => x !== _id);
      });
    }
  };

  const handleSubmit = () => {
    if (selectedItems.length < 2)
      return Alert.alert('Oh no!', 'Please select at least two options');

    navigate('Compare', {
      selected: selectedItems,
      itemType: state.params.itemType
    });
  };

  if (loading) return <LoadingIndicator />;

  return (
    <>
      <ScrollView>
        {Object.entries(docs).map(([type, items]) => {
          if (items.length)
            return (
              <React.Fragment key={type}>
                <Text>{localeString(type)}</Text>
                {items.map((item) => (
                  <ListItem
                    key={item._id}
                    title={item.name}
                    containerStyle={{backgroundColor: 'black'}}
                    titleStyle={{color: 'white'}}
                    bottomDivider
                    onPress={() => handleSelect(item)}
                    rightElement={
                      <CheckBox
                        value={selectedItems.includes(item._id)}
                        onPress={() => handleSelect(item)}
                        tintColors={{
                          false: theme.colors.almostBlack,
                          true: theme.colors.orange
                        }}
                      />
                    }
                  />
                ))}
              </React.Fragment>
            );
        })}
        {/* {state.map((x, i) => (
          <ListItem
            key={i}
            title={x.text}
            containerStyle={{backgroundColor: 'black'}}
            titleStyle={{color: 'white'}}
            bottomDivider
            onPress={() => handleSelect(x)}
            rightElement={
              <CheckBox
                value={x.selected}
                onPress={() => handleSelect(x)}
                tintColors={{
                  false: theme.colors.almostBlack,
                  true: theme.colors.orange
                }}
              />
            }
          />
        ))} */}
      </ScrollView>
      <Button
        title="Continue"
        color={theme.colors.orange}
        onPress={handleSubmit}
      />
    </>
  );
};

SelectCompareScreen.navigationOptions = {
  title: 'Compare to..',
  headerStyle: {
    backgroundColor: '#191919'
  },
  headerTintColor: '#FF491C',
  headerTitleStyle: {
    fontSize: 28
  }
};

SelectCompareScreen.propTypes = {};

export default SelectCompareScreen;
