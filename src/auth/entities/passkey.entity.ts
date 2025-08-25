import { BaseModel } from '@/database/models/base.model';
import { Column, Entity, JoinColumn, ManyToOne } from 'typeorm';
import { UserEntity } from './user.entity';

// https://www.better-auth.com/docs/plugins/passkey#schema
@Entity('passkeys')
export class PassKeyEntity extends BaseModel {
  @Column({ nullable: true })
  name: string;

  @Column({ name: 'user_id' })
  userId: string;

  @ManyToOne(() => UserEntity, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'user_id' })
  user: UserEntity;

  @Column({ name: 'public_key' })
  publicKey: string;

  @Column({ name: 'credential_id' })
  credentialID: string;

  @Column()
  counter: number;

  @Column({ name: 'device_type' })
  deviceType: string;

  @Column({ type: 'boolean', name: 'backed_up' })
  backedUp: boolean;

  @Column()
  transports: string;
}
