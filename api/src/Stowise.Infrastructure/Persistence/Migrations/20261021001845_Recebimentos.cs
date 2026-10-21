using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Stowise.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class Recebimentos : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "recebimentos",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    fornecedor_id = table.Column<Guid>(type: "uuid", nullable: false),
                    chave_acesso = table.Column<string>(type: "character(44)", fixedLength: true, maxLength: 44, nullable: false),
                    numero = table.Column<int>(type: "integer", nullable: false),
                    serie = table.Column<int>(type: "integer", nullable: false),
                    data_emissao = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    status = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false),
                    data_chegada = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    criado_por = table.Column<Guid>(type: "uuid", nullable: false),
                    criado_em = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    xmin = table.Column<uint>(type: "xid", rowVersion: true, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_recebimentos", x => x.id);
                    table.ForeignKey(
                        name: "fk_recebimentos_fornecedores_fornecedor_id",
                        column: x => x.fornecedor_id,
                        principalTable: "fornecedores",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "recebimento_itens",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    recebimento_id = table.Column<Guid>(type: "uuid", nullable: false),
                    numero_item = table.Column<int>(type: "integer", nullable: false),
                    produto_id = table.Column<Guid>(type: "uuid", nullable: false),
                    produto_fornecedor_id = table.Column<Guid>(type: "uuid", nullable: false),
                    embalagem_id = table.Column<Guid>(type: "uuid", nullable: false),
                    codigo_fornecedor = table.Column<string>(type: "character varying(60)", maxLength: 60, nullable: false),
                    descricao_nota = table.Column<string>(type: "character varying(120)", maxLength: 120, nullable: false),
                    unidade_nota = table.Column<string>(type: "character varying(6)", maxLength: 6, nullable: false),
                    quantidade_nota = table.Column<decimal>(type: "numeric(18,4)", precision: 18, scale: 4, nullable: false),
                    fator_conversao = table.Column<decimal>(type: "numeric(18,4)", precision: 18, scale: 4, nullable: false),
                    quantidade = table.Column<decimal>(type: "numeric(18,4)", precision: 18, scale: 4, nullable: false),
                    cfop = table.Column<string>(type: "character(4)", fixedLength: true, maxLength: 4, nullable: false),
                    valor_unitario = table.Column<decimal>(type: "numeric(18,4)", precision: 18, scale: 4, nullable: false),
                    lotes = table.Column<string>(type: "jsonb", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_recebimento_itens", x => x.id);
                    table.ForeignKey(
                        name: "fk_recebimento_itens_produto_embalagens_embalagem_id",
                        column: x => x.embalagem_id,
                        principalTable: "produto_embalagens",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_recebimento_itens_produto_fornecedores_produto_fornecedor_id",
                        column: x => x.produto_fornecedor_id,
                        principalTable: "produto_fornecedores",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_recebimento_itens_produtos_produto_id",
                        column: x => x.produto_id,
                        principalTable: "produtos",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_recebimento_itens_recebimentos_recebimento_id",
                        column: x => x.recebimento_id,
                        principalTable: "recebimentos",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "recebimento_xmls",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    recebimento_id = table.Column<Guid>(type: "uuid", nullable: false),
                    conteudo = table.Column<byte[]>(type: "bytea", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_recebimento_xmls", x => x.id);
                    table.ForeignKey(
                        name: "fk_recebimento_xmls_recebimentos_recebimento_id",
                        column: x => x.recebimento_id,
                        principalTable: "recebimentos",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "ix_recebimento_itens_embalagem_id",
                table: "recebimento_itens",
                column: "embalagem_id");

            migrationBuilder.CreateIndex(
                name: "ix_recebimento_itens_produto_fornecedor_id",
                table: "recebimento_itens",
                column: "produto_fornecedor_id");

            migrationBuilder.CreateIndex(
                name: "ix_recebimento_itens_produto_id",
                table: "recebimento_itens",
                column: "produto_id");

            migrationBuilder.CreateIndex(
                name: "ix_recebimento_itens_recebimento_id_numero_item",
                table: "recebimento_itens",
                columns: new[] { "recebimento_id", "numero_item" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "ix_recebimento_xmls_recebimento_id",
                table: "recebimento_xmls",
                column: "recebimento_id",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "ix_recebimentos_chave_acesso",
                table: "recebimentos",
                column: "chave_acesso",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "ix_recebimentos_fornecedor_id",
                table: "recebimentos",
                column: "fornecedor_id");

            migrationBuilder.CreateIndex(
                name: "ix_recebimentos_status_criado_em",
                table: "recebimentos",
                columns: new[] { "status", "criado_em" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "recebimento_itens");

            migrationBuilder.DropTable(
                name: "recebimento_xmls");

            migrationBuilder.DropTable(
                name: "recebimentos");
        }
    }
}
