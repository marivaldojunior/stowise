using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Stowise.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddEstoque : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "lotes",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    produto_id = table.Column<Guid>(type: "uuid", nullable: false),
                    numero = table.Column<string>(type: "character varying(40)", maxLength: 40, nullable: false),
                    fabricacao = table.Column<DateOnly>(type: "date", nullable: true),
                    validade = table.Column<DateOnly>(type: "date", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_lotes", x => x.id);
                    table.ForeignKey(
                        name: "fk_lotes_produtos_produto_id",
                        column: x => x.produto_id,
                        principalTable: "produtos",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "movimentacoes",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    tipo = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false),
                    produto_id = table.Column<Guid>(type: "uuid", nullable: false),
                    lote_id = table.Column<Guid>(type: "uuid", nullable: true),
                    endereco_origem_id = table.Column<Guid>(type: "uuid", nullable: true),
                    endereco_destino_id = table.Column<Guid>(type: "uuid", nullable: true),
                    quantidade = table.Column<decimal>(type: "numeric(18,4)", precision: 18, scale: 4, nullable: false),
                    documento_referencia = table.Column<string>(type: "character varying(60)", maxLength: 60, nullable: true),
                    observacao = table.Column<string>(type: "character varying(250)", maxLength: 250, nullable: true),
                    usuario_id = table.Column<Guid>(type: "uuid", nullable: false),
                    dispositivo_id = table.Column<Guid>(type: "uuid", nullable: true),
                    ocorrido_em = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    recebido_em = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_movimentacoes", x => x.id);
                    table.CheckConstraint("ck_movimentacoes_quantidade", "quantidade > 0");
                    table.ForeignKey(
                        name: "fk_movimentacoes_enderecos_endereco_destino_id",
                        column: x => x.endereco_destino_id,
                        principalTable: "enderecos",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_movimentacoes_enderecos_endereco_origem_id",
                        column: x => x.endereco_origem_id,
                        principalTable: "enderecos",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_movimentacoes_lotes_lote_id",
                        column: x => x.lote_id,
                        principalTable: "lotes",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_movimentacoes_produtos_produto_id",
                        column: x => x.produto_id,
                        principalTable: "produtos",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_movimentacoes_usuarios_usuario_id",
                        column: x => x.usuario_id,
                        principalTable: "usuarios",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "saldos",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    endereco_id = table.Column<Guid>(type: "uuid", nullable: false),
                    produto_id = table.Column<Guid>(type: "uuid", nullable: false),
                    lote_id = table.Column<Guid>(type: "uuid", nullable: true),
                    quantidade = table.Column<decimal>(type: "numeric(18,4)", precision: 18, scale: 4, nullable: false),
                    quantidade_reservada = table.Column<decimal>(type: "numeric(18,4)", precision: 18, scale: 4, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_saldos", x => x.id);
                    table.CheckConstraint("ck_saldos_quantidades", "quantidade >= 0 AND quantidade_reservada >= 0 AND quantidade_reservada <= quantidade");
                    table.ForeignKey(
                        name: "fk_saldos_enderecos_endereco_id",
                        column: x => x.endereco_id,
                        principalTable: "enderecos",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_saldos_lotes_lote_id",
                        column: x => x.lote_id,
                        principalTable: "lotes",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_saldos_produtos_produto_id",
                        column: x => x.produto_id,
                        principalTable: "produtos",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "ix_lotes_produto_id_numero",
                table: "lotes",
                columns: new[] { "produto_id", "numero" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "ix_movimentacoes_endereco_destino_id",
                table: "movimentacoes",
                column: "endereco_destino_id");

            migrationBuilder.CreateIndex(
                name: "ix_movimentacoes_endereco_origem_id",
                table: "movimentacoes",
                column: "endereco_origem_id");

            migrationBuilder.CreateIndex(
                name: "ix_movimentacoes_lote_id",
                table: "movimentacoes",
                column: "lote_id");

            migrationBuilder.CreateIndex(
                name: "ix_movimentacoes_produto_id_ocorrido_em",
                table: "movimentacoes",
                columns: new[] { "produto_id", "ocorrido_em" });

            migrationBuilder.CreateIndex(
                name: "ix_movimentacoes_usuario_id",
                table: "movimentacoes",
                column: "usuario_id");

            migrationBuilder.CreateIndex(
                name: "ix_saldos_endereco_id_produto_id_lote_id",
                table: "saldos",
                columns: new[] { "endereco_id", "produto_id", "lote_id" },
                unique: true)
                .Annotation("Npgsql:NullsDistinct", false);

            migrationBuilder.CreateIndex(
                name: "ix_saldos_lote_id",
                table: "saldos",
                column: "lote_id");

            migrationBuilder.CreateIndex(
                name: "ix_saldos_produto_id",
                table: "saldos",
                column: "produto_id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "movimentacoes");

            migrationBuilder.DropTable(
                name: "saldos");

            migrationBuilder.DropTable(
                name: "lotes");
        }
    }
}
