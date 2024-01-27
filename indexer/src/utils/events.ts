import { selector } from 'starknet'
import { abi } from "./const";
import { deserializeOldEvent } from './events-old';
import { Block } from '../entity/block';

const { getSelectorFromName } = selector;

type Field = { name: string, type: string };
type StructsDefinition = Record<string, Field[]>;
const structs = abi.filter(entry => entry.type === "struct").reduce<StructsDefinition>((acc, entry) => {
    acc[entry.name] = entry.members!;
    return acc;
}, {});

type EventDefinition = { name: string, fields: Field[] }
type Hash = string;
const events = abi.filter(entry => entry.type === "event").reduce<Record<Hash, EventDefinition>>((acc, entry) => {
    const hash = getSelectorFromName(entry.name);
    // @ts-ignore
    acc[hash] = {name: entry.name, fields: entry.members!};
    return acc;
}, {});


type DeserializedEvent = {
    name: string;
    value: Record<string, any>;
}

const uint256Shift = BigInt("0x100000000000000000000000000000000");

// Mutates values!
const deserializeValue = (type: string, values: string[]): any => {
    if(!values.length) {
        return;
    }

    if (type === "felt252" || type === "ContractAddress") {
        const [value] = values.splice(0, 1);
        return BigInt(value);
    }

    if (type === "u256") {
        const [low, high] = values.splice(0, 2);
        if(low && high){
            return BigInt(low) + BigInt(high) * uint256Shift;
        }
    }

    const structFields = structs[type];
    if(structFields) {
        return deserializeStruct(structFields, values);
    }
}

// Mutates values!
const deserializeStruct = (fields: Field[], values: string[]): Record<string, any> =>
    {
        return fields.reduce<Record<string, any>>((acc, field, i) => {
                const value = deserializeValue(field.type, values);
                if(value !== undefined){
                    acc[field.name] = value;
                }
            return acc;
        }, {});
    }

export const deserializeEvent = (key: string, data: string[]): DeserializedEvent => {
    const eventDefinition = events[key];
    const value = deserializeStruct(eventDefinition.fields || [], [...data]);
    return {name: eventDefinition.name, value}
}

export const parseEventContent = (
    event: any,
    block: Block
  ): DeserializedEvent | undefined => {
    let processed;
    const [functName, ...initialData] = event.keys;
    const upgradedBlockStart =
      Number(process.env.UPGRADED_CONTRACT_BLOCK_START) ?? 0;
  
    if (block.blockIndex >= upgradedBlockStart) {
      try {
        processed = deserializeEvent(functName, [...initialData, ...event.data]);
      } catch (e) {
        console.debug(
          "Could not parse event content with new parser. Trying old parser."
        );
      }
  
      if (!processed) {
        try {
          processed = deserializeOldEvent(functName, event.data);
        } catch (e) {
          console.debug("Could not parse event content with old parser.");
        }
      }
    } else {
      try {
        processed = deserializeOldEvent(functName, event.data);
      } catch (e) {
        console.debug("Could not parse event content with old parser. Trying new parser.");
      }
  
      if (!processed) {
        try {
          processed = deserializeEvent(functName, [
            ...initialData,
            ...event.data,
          ]);
        } catch (e) {
          console.debug(
            "Could not parse event content with new parser. Trying old parser."
          );
        }
      }
    }
  
    return processed;
  };
  