import {Index, PrimaryColumn, ViewColumn, ViewEntity} from "typeorm";

@ViewEntity({
    expression: `
        select event."txHash"                                    "transactionHash",
               event."name"                                      "transactionType",
               (event.content -> 'user_id')::numeric             "transactionOwner",
               (event.content -> 'generation')::numeric          "gameGeneration",
               (event.content -> 'state')::numeric               "gameState",
               (event.content -> 'cell_index')::numeric          "revivedCellIndex",
               transaction.status                                "txStatus",
               (
                  case
                      when (event.content -> 'state')::numeric=0 then true
                      else false
                      end
                ) as "gameExtinct",
               event."createdAt"                                 "createdAt"
        from event
            left join transaction
                on event."txHash" = transaction.hash
        where (event.name='game_evolved'
               AND (event.content -> 'game_id')::numeric = 39132555273291485155644251043342963441664)
               OR event.name='cell_revived';
    `,
    materialized: true,
})
// WARNING: INDICES HAVE TO BE CREATED MANUALLY IN MIGRATIONS, EVERY TIME THIS VIEW IS EDITED
@Index(["transactionType", "transactionOwner", "createdAt", "gameExtinct", "txStatus"])
export class Infinite {
    @PrimaryColumn()
    @ViewColumn()
    transactionHash!: string

    @ViewColumn()
    transactionType!: string;

    @ViewColumn()
    transactionOwner!: string;

    @ViewColumn()
    revivedCellIndex!: number;

    @ViewColumn()
    gameGeneration!: number;

    @ViewColumn()
    gameState!: number;

    @ViewColumn()
    createdAt!: string;

    @ViewColumn()
    gameExtinct!: boolean

    @ViewColumn()
    txStatus!: string;
}
