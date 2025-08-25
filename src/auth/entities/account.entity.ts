import { BaseModel } from '@/database/models/base.model';
import { Column, Entity, JoinColumn, ManyToOne } from 'typeorm';
import { UserEntity } from './user.entity';

// https://www.better-auth.com/docs/concepts/database#core-schema
@Entity('accounts')
export class AccountEntity extends BaseModel {
  @Column({ name: 'user_id' })
  userId: string;

  @ManyToOne(() => UserEntity, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'user_id' })
  user: UserEntity;

  @Column({ name: 'account_id' })
  accountId: string;

  @Column({ type: 'varchar', name: 'provider_id' })
  providerId: 'credential';

  @Column({ nullable: true, name: 'access_token' })
  accessToken: string;

  @Column({ nullable: true, name: 'refresh_token' })
  refreshToken: string;

  @Column({
    type: 'timestamp',
    nullable: true,
    name: 'access_token_expires_at',
  })
  accessTokenExpiresAt: Date;

  @Column({
    type: 'timestamp',
    nullable: true,
    name: 'refresh_token_expires_at',
  })
  refreshTokenExpiresAt: Date;

  @Column({ nullable: true })
  scope: string;

  @Column({ nullable: true, name: 'id_token' })
  idToken: string;

  @Column({ nullable: true })
  password: string;
}
