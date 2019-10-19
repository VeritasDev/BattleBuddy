import React, {useEffect, useState} from 'react';
import styled from 'styled-components/native';
import numbersToPercentages from '../../../utils/numbersToPercentage';
import LoadingIndicator from '../../../components/common/LoadingIndicator';
import useCollection from '../../../hooks/useCollection';
import getDescendantProp from '../../../utils/getDescendantProp';
import {useNavigation} from 'react-navigation-hooks';
import calculateRedValue from '../../../utils/calculateRedValue';
import CompareValuesByType from './CompareValuesByType';
import localeString from '../../../utils/localeString';

const ScrollView = styled.ScrollView`
  background: ${({theme}) => theme.colors.background};
`;

const Text = styled.Text`
  color: white;
  margin: 10px 0 5px 10px;
  font-size: 20px;
  text-transform: uppercase;
`;

const Name = styled.Text`
  position: absolute;
  color: white;
  z-index: 100;
  left: 5px;
  top: 2px;
  font-weight: bold;
`;

const Value = styled(Name)`
  right: 20px;
  left: auto;
`;

const Bar = styled.View`
  background: rgb(
    ${({index, totalAmount}) => calculateRedValue(index, totalAmount)},
    59,
    77
  );
  width: ${(props) => props.width || 1}%;
  height: 100%;
`;

const BarContainer = styled.View`
  width: 400px;
  height: 24px;
  background: black;
  margin-bottom: 2px;
  position: relative;
`;

// Construct Graph data
const constructGraphData = (dataSet, itemType) => {
  // Retreive comparison types for specific ItemType. Check file.
  const comparisonTypesForItem = [...CompareValuesByType[itemType]];

  // Iterate of each comparison type e.g. 'Fire Rate' etc for 'Weapons'
  return comparisonTypesForItem.map(({property, onRender, ...rest}) => {
    // Make array for Fire Rate of each weapon and convet numbers
    // Into percentages
    const percentageValues = numbersToPercentages(
      dataSet.map((d) =>
        // if a specific type has an onRender function, use onRender instead
        // of raw value. For example: armor.zones is an array with specific
        // areas but we show the number of areas in graph. Take a look at
        // CompareValuesByType in file for example.
        onRender
          ? onRender(getDescendantProp(d, property)) // getDescendantProp returns prop of object by dot notation.
          : getDescendantProp(d, property)
      )
    );

    // To make the data that's iterated over during render as small as
    // Possible, I only use the values here which are needed.
    return {
      title: property,
      onRender,
      data: dataSet.map((d, i) => {
        return {
          id: d._id,
          percentage: percentageValues[i],
          shortName: d.shortName,
          value: getDescendantProp(d, property)
        };
      }),
      ...rest
    };
  });
};

const ComparisonScreen = () => {
  // Retreive params from navigation props
  const {
    state: {
      params: {selected, itemType}
    }
  } = useNavigation();

  // Fetch collection for ItemType
  const {data, loading} = useCollection(itemType);
  const [graphData, setGraphData] = useState();

  useEffect(() => {
    if (!loading) {
      const dataSet = constructGraphData(data, itemType);
      setGraphData(dataSet);
    }
  }, [loading]);

  // Whilst loading, show Loading indicator
  if (loading) return <LoadingIndicator />;

  const determineValue = (value, {onRender, bindValue}) => {
    if (bindValue) {
      return onRender ? bindValue[onRender(value)] : bindValue[value];
    }

    return onRender ? onRender(value) : value;
  };

  return (
    <ScrollView>
      {graphData &&
        graphData.map((graph) => (
          <React.Fragment key={graph.title}>
            <Text>{localeString(graph.title)}</Text>
            {graph.data
              .filter((d) => selected.includes(d.id))
              .map((d, i) => (
                <BarContainer key={d.id}>
                  <Name>{d.shortName}</Name>
                  <Bar
                    width={d.percentage}
                    index={i}
                    totalAmount={
                      graph.data.filter((d) => selected.includes(d.id)).length
                    }
                  />
                  <Value>
                    {graph.prefix && graph.prefix}
                    {determineValue(d.value, graph)}
                    {graph.suffix && graph.suffix}
                  </Value>
                </BarContainer>
              ))}
          </React.Fragment>
        ))}
    </ScrollView>
  );
};

ComparisonScreen.navigationOptions = {
  title: 'Compare',
  headerStyle: {
    backgroundColor: '#191919'
  },
  headerTintColor: '#FF491C',
  headerTitleStyle: {
    fontSize: 28
  }
};

ComparisonScreen.propTypes = {};

export default ComparisonScreen;
