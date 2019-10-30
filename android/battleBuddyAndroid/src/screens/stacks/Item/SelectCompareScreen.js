import React, {useState, useEffect} from 'react';

import {ListItem} from 'react-native-elements';
import CheckBox from '@react-native-community/checkbox';
import styled from 'styled-components/native';
import {theme} from '../../../components/Theme';
import {Button, Alert} from 'react-native';
import {useItems} from '../../../context/ItemProvider';
import {useNavigation} from 'react-navigation-hooks';
import localeString from '../../../utils/localeString';
import LoadingIndicator from '../../../components/common/LoadingIndicator';
import ItemType from '../../../constants/ItemType';

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

  const {loading, data: docs, setCollectionName, clearData} = useItems();

  useEffect(() => {
    setCollectionName(state.params.itemType);

    return () => {
      if (state.params.fromSearch) {
        clearData;
      }
    };
  }, []);

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
  console.log(docs);
  return (
    <>
      <ScrollView>
        {state.params.itemType === ItemType.melee
          ? docs.map((item) => (
              <ListItem
                key={item._id}
                title={item.name}
                containerStyle={{backgroundColor: 'black'}}
                titleStyle={{color: 'white'}}
                bottomDivider
                onPress={() => handleSelect(item)}
                rightElement={
                  <CheckBox
                    disabled
                    value={selectedItems.includes(item._id)}
                    tintColors={{
                      false: theme.colors.almostBlack,
                      true: theme.colors.orange
                    }}
                  />
                }
              />
            ))
          : docs.map((section) => {
              if (section.data.length)
                return (
                  <React.Fragment key={section.title}>
                    <Text>
                      {state.params.itemType === ItemType.ammo
                        ? section.title
                        : localeString(section.title)}
                    </Text>
                    {section.data.map((item) => (
                      <ListItem
                        key={item._id}
                        title={item.name}
                        containerStyle={{backgroundColor: 'black'}}
                        titleStyle={{color: 'white'}}
                        bottomDivider
                        onPress={() => handleSelect(item)}
                        rightElement={
                          <CheckBox
                            disabled
                            value={selectedItems.includes(item._id)}
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
  title: 'Compare to..'
};

SelectCompareScreen.propTypes = {};

export default SelectCompareScreen;
