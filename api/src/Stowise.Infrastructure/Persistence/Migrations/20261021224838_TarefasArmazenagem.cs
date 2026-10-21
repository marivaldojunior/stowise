using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Stowise.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class TarefasArmazenagem : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "tarefas_armazenagem",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    recebimento_id = table.Column<Guid>(type: "uuid", nullable: false),
                    recebimento_item_id = table.Column<Guid>(type: "uuid", nullable: false),
                    produto_id = table.Column<Guid>(type: "uuid", nullable: false),
                    lote_numero = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: true),
                    lote_fabricacao = table.Column<DateOnly>(type: "date", nullable: true),
                    lote_validade = table.Column<DateOnly>(type: "date", nullable: true),
                    quantidade = table.Column<decimal>(type: "numeric(18,4)", precision: 18, scale: 4, nullable: false),
                    endereco_sugerido_id = table.Column<Guid>(type: "uuid", nullable: true),
                    pontuacao = table.Column<decimal>(type: "numeric(18,4)", precision: 18, scale: 4, nullable: true),
                    notas = table.Column<string>(type: "jsonb", nullable: false),
                    regras_versao = table.Column<string>(type: "character(12)", fixedLength: true, maxLength: 12, nullable: false),
                    status = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false),
                    endereco_confirmado_id = table.Column<Guid>(type: "uuid", nullable: true),
                    motivo_divergencia = table.Column<string>(type: "character varying(250)", maxLength: 250, nullable: true),
                    movimentacao_id = table.Column<Guid>(type: "uuid", nullable: true),
                    concluido_por = table.Column<Guid>(type: "uuid", nullable: true),
                    criado_em = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    concluido_em = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    xmin = table.Column<uint>(type: "xid", rowVersion: true, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_tarefas_armazenagem", x => x.id);
                    table.ForeignKey(
                        name: "fk_tarefas_armazenagem_enderecos_endereco_confirmado_id",
                        column: x => x.endereco_confirmado_id,
                        principalTable: "enderecos",
                        principalColumn: "id",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "fk_tarefas_armazenagem_enderecos_endereco_sugerido_id",
                        column: x => x.endereco_sugerido_id,
                        principalTable: "enderecos",
                        principalColumn: "id",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "fk_tarefas_armazenagem_movimentacoes_movimentacao_id",
                        column: x => x.movimentacao_id,
                        principalTable: "movimentacoes",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_tarefas_armazenagem_produtos_produto_id",
                        column: x => x.produto_id,
                        principalTable: "produtos",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_tarefas_armazenagem_recebimento_itens_recebimento_item_id",
                        column: x => x.recebimento_item_id,
                        principalTable: "recebimento_itens",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_tarefas_armazenagem_recebimentos_recebimento_id",
                        column: x => x.recebimento_id,
                        principalTable: "recebimentos",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "ix_tarefas_armazenagem_endereco_confirmado_id",
                table: "tarefas_armazenagem",
                column: "endereco_confirmado_id");

            migrationBuilder.CreateIndex(
                name: "ix_tarefas_armazenagem_endereco_sugerido_id",
                table: "tarefas_armazenagem",
                column: "endereco_sugerido_id");

            migrationBuilder.CreateIndex(
                name: "ix_tarefas_armazenagem_movimentacao_id",
                table: "tarefas_armazenagem",
                column: "movimentacao_id");

            migrationBuilder.CreateIndex(
                name: "ix_tarefas_armazenagem_produto_id",
                table: "tarefas_armazenagem",
                column: "produto_id");

            migrationBuilder.CreateIndex(
                name: "ix_tarefas_armazenagem_recebimento_id",
                table: "tarefas_armazenagem",
                column: "recebimento_id");

            migrationBuilder.CreateIndex(
                name: "ix_tarefas_armazenagem_recebimento_item_id",
                table: "tarefas_armazenagem",
                column: "recebimento_item_id");

            migrationBuilder.CreateIndex(
                name: "ix_tarefas_armazenagem_status_criado_em",
                table: "tarefas_armazenagem",
                columns: new[] { "status", "criado_em" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "tarefas_armazenagem");
        }
    }
}
