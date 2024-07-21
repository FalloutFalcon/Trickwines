import { resolveAsset } from '../../assets';
import { useBackend, useLocalState } from '../../backend';
import {
  NoticeBox,
  Section,
  Stack,
  Table,
  Tooltip,
  Button,
  Box,
  Flex,
  Icon
} from '../../components';

import { capitalizeFirst } from 'common/string';

import { getDisplayColor, getDisplayName, searchFor, compareNumberedText} from './helpers';
import { Antagonist, Observable, OrbitData } from './types';

type Props = {
  item: Observable | Antagonist;
  color: string | undefined;
};

export const OrbitItem = (props: Props, context) => {
  const { item, color } = props;
  const { full_name, icon, job, name, orbiters, ref } = item;

  const { act, data } = useBackend<OrbitData>(context);
  const { orbiting } = data;

  const selected = ref === orbiting?.ref;
  const validIcon = !!job && !!icon && icon !== 'hudunknown';


  return (
    <Flex.Item
      mb={0.5}
      mr={0.5}
      onClick={() => act('orbit', { ref })}
      style={{
        display: 'flex',
      }}
    >
      <Button
        color={getDisplayColor(item, color)}
        pl={validIcon && 0.5}
      >
        <Stack>
          <Stack.Item>
            {capitalizeFirst(getDisplayName(full_name, name))}
          </Stack.Item>
          {!!orbiters && (
            <Stack.Item>
              <Icon name="ghost" />
              {orbiters}
            </Stack.Item>
          )}
        </Stack>
        {selected && <div className="OrbitItem__selected" />}
      </Button>
    </Flex.Item>
  );
}
