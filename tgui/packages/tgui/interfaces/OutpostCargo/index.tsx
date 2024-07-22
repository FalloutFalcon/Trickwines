import { useBackend, useSharedState } from '../../backend';
import {
  Blink,
  Box,
  Button,
  Dimmer,
  Flex,
  Icon,
  Input,
  Modal,
  Section,
  TextArea,
  Tabs,
  Stack,
} from '../../components';
import { Window } from '../../layouts';

import { CargoCart } from './CargoCart';
import { CargoCatalog } from './CargoCatalog';
import { CargoData, SupplyPack } from './types';

export const OutpostCargo = (props, context) => {
  const { act, data } = useBackend<CargoData>(context);
  const { supply_packs = [] } = data;
  const [tab, setTab] = useSharedState(context, 'outpostTab', 'catalog');

  return (
    <Window width={800} height={700} resizable>
      <Window.Content>
        <Flex>
          <Stack vertical width={'60%'} pr="3px">
            <Tabs>
              <Tabs.Tab
                selected={tab === 'catalog'}
                onClick={() => setTab('catalog')}
              >
                Catalog
              </Tabs.Tab>
              <Tabs.Tab
                selected={tab === 'cart'}
                onClick={() => setTab('cart')}
              >
                Cart
              </Tabs.Tab>
            </Tabs>
            {tab === 'catalog' && <CargoCatalog />}
            {tab === 'cart' && <CargoCart />}
          </Stack>
          <Section title="Pack: .38 Match Grade Speedloader">
            <p>Cost: 1 billion credits</p>
            <p>Stock</p>
            <p>Seller: SRM</p>
            <p>Desc Lore Ipsum</p>
          </Section>
        </Stack>
      </Window.Content>
    </Window>
  );
};
