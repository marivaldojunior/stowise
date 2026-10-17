using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Stowise.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class TransferenciaEReservas : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "reservas",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    endereco_id = table.Column<Guid>(type: "uuid", nullable: false),
                    produto_id = table.Column<Guid>(type: "uuid", nullable: false),
                    lote_id = table.Column<Guid>(type: "uuid", nullable: true),
                    quantidade = table.Column<decimal>(type: "numeric(18,4)", precision: 18, scale: 4, nullable: false),
                    documento_referencia = table.Column<string>(type: "character varying(60)", maxLength: 60, nullable: true),
                    status = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false),
                    criada_por = table.Column<Guid>(type: "uuid", nullable: false),
                    criada_em = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    encerrada_por = table.Column<Guid>(type: "uuid", nullable: true),
                    encerrada_em = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    movimentacao_id = table.Column<Guid>(type: "uuid", nullable: true),
                    xmin = table.Column<uint>(type: "xid", rowVersion: true, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_reservas", x => x.id);
                    table.CheckConstraint("ck_reservas_quantidade", "quantidade > 0");
                    table.ForeignKey(
                        name: "fk_reservas_enderecos_endereco_id",
                        column: x => x.endereco_id,
                        principalTable: "enderecos",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_reservas_lotes_lote_id",
                        column: x => x.lote_id,
                        principalTable: "lotes",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_reservas_movimentacoes_movimentacao_id",
                        column: x => x.movimentacao_id,
                        principalTable: "movimentacoes",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_reservas_produtos_produto_id",
                        column: x => x.produto_id,
                        principalTable: "produtos",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_reservas_usuarios_criada_por",
                        column: x => x.criada_por,
                        principalTable: "usuarios",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "ix_reservas_criada_por",
                table: "reservas",
                column: "criada_por");

            migrationBuilder.CreateIndex(
                name: "ix_reservas_documento_referencia",
                table: "reservas",
                column: "documento_referencia");

            migrationBuilder.CreateIndex(
                name: "ix_reservas_endereco_id_produto_id_lote_id_status",
                table: "reservas",
                columns: new[] { "endereco_id", "produto_id", "lote_id", "status" });

            migrationBuilder.CreateIndex(
                name: "ix_reservas_lote_id",
                table: "reservas",
                column: "lote_id");

            migrationBuilder.CreateIndex(
                name: "ix_reservas_movimentacao_id",
                table: "reservas",
                column: "movimentacao_id");

            migrationBuilder.CreateIndex(
                name: "ix_reservas_produto_id",
                table: "reservas",
                column: "produto_id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "reservas");
        }
    }
}
